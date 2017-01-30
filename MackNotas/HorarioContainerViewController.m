//
//  HorarioContainerViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 02/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "HorarioContainerViewController.h"

/**
 *  Controller
 */
#import "LoginViewController.h"
#import "SettingsViewController.h"
#import "LoadingViewController.h"

/**
 *  Models
 */
#import "MNHorario+Persistence.h"

/**
 *  Helpers
 */
#import "ConnectionHelper.h"
#import "UIView+MackNotas.h"

@interface HorarioContainerViewController ()

/**
 *  Primitives
 */
@property (nonatomic) NSInteger currentPage;
@property (nonatomic) NSInteger lastBtnDay;

@property (nonatomic) BOOL hasReachedEnd;
@property (nonatomic) BOOL hasEmptySchedule;

/**
 Controller
 */
@property (nonatomic) HorarioGenericViewController *horarioGenericViewFirst;
@property (nonatomic) UIPageViewController *pageViewController;
//@property (nonatomic) LoadingViewController *loadingView;

/**
 Arrays
 */
//@property (nonatomic) NSArray *arrayMaterias;
//@property (nonatomic) NSArray *arrayHoras;

/**
 Constraints
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrViewIndicatorX;

/**
 Views
 */
@property (strong, nonatomic) IBOutlet UIView *viewIndicator;
@property (strong, nonatomic) IBOutlet UIView *viewButtons;
@property (strong, nonatomic) IBOutlet UIView *viewPageContainer;

/**
 DB objects
 */
@property (nonatomic) YapDatabaseViewMappings *mappings;

@end

@implementation HorarioContainerViewController

- (instancetype)init {

    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];
    if (self) {
        self.title = @"Horários";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_horario"];
        self.currentPage = 0;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeAutoRequestNotification)
                                                     name:kSettingsViewControllerWillLogoutUserNotification object:nil];
        _lastBtnDay = 0;

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(persistenceManagerDidUpdate:)
         name:DBManagerDidUpdateNotification
         object:[DBManager sharedInstance]];

        _mappings = [[YapDatabaseViewMappings alloc]initWithGroups:@[MNHorarioGroupName]
                                                                  view:MNHorarioViewName];

        [[DBManager sharedInstance].uiConnection beginLongLivedReadTransaction];
        [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            [_mappings updateWithTransaction:transaction];
        }];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self initializePageViewController];

    self.viewButtons.backgroundColor = [UIColor vermelhoMainBackground];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [self userInteracionEnabledOnViews:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if ([self.mappings numberOfItemsInGroup:MNHorarioGroupName] > 0) {
            [self moveToDayBasedOnDate];
        }
    });
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [GAHelper trackViewWithName:NSStringFromClass(self.class)];
    [self verifyLoggedUserSkippingCache:NO
                             withViewId:0];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self removeAutoRequestNotification];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {

    [self verifyLoggedUserSkippingCache:NO
                             withViewId:0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)initializePageViewController {

    self.pageViewController = [[UIPageViewController alloc]
                               initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll
                               navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal
                               options:nil];

    self.pageViewController.dataSource = self;
    self.pageViewController.delegate = self;

    [self addChildViewController:self.pageViewController];

    CGRect viewPageContainerFrame = self.viewPageContainer.frame;
    viewPageContainerFrame.origin.y = 0.0f;

    self.pageViewController.view.frame = viewPageContainerFrame;

    self.horarioGenericViewFirst = [HorarioGenericViewController new];
    self.horarioGenericViewFirst.delegate = self;

    self.horarioGenericViewFirst.restorationIdentifier = @"0";

    [self.pageViewController setViewControllers:@[self.horarioGenericViewFirst]
                                      direction:UIPageViewControllerNavigationDirectionForward
                                       animated:YES
                                     completion:nil];

    [self.viewPageContainer addSubview:self.pageViewController.view];
    [self.pageViewController didMoveToParentViewController:self];

    if ([self.mappings numberOfItemsInGroup:MNHorarioGroupName] > 0) {
        [self reloadFirstViewController];
    }
}

#pragma mark - UIPageViewController DataSource

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
       viewControllerAfterViewController:(HorarioGenericViewController *)viewController {

    if (viewController.restorationIdentifier.integerValue == 5) {
        return nil;
    }

    NSInteger indexView = viewController.restorationIdentifier.integerValue;

    return [self horarioGenericViewWithId:indexView + 1];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController
      viewControllerBeforeViewController:(HorarioGenericViewController *)viewController {

    if (viewController.restorationIdentifier.integerValue == 0) {
        return nil;
    }

    NSInteger indexView = viewController.restorationIdentifier.integerValue;

    return [self horarioGenericViewWithId:indexView - 1];
}

- (void)pageViewController:(UIPageViewController *)pageViewController
        didFinishAnimating:(BOOL)finished
   previousViewControllers:(NSArray *)previousViewControllers
       transitionCompleted:(BOOL)completed {

    if (completed) {
        NSInteger viewIndex = [pageViewController.viewControllers[0] restorationIdentifier].integerValue;
        [self userInteracionEnabledOnViews:YES];

        if (self.lastBtnDay < viewIndex) {
            [self animateIndicatorWithXPosition:self.viewIndicator.frame.size.width];
        }
        else {
            [self animateIndicatorWithXPosition:-self.viewIndicator.frame.size.width];
        }

        self.lastBtnDay = viewIndex;
    }
    else if (finished) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self userInteracionEnabledOnViews:YES];
        });
    }
}

- (void)pageViewController:(UIPageViewController *)pageViewController
willTransitionToViewControllers:(NSArray *)pendingViewControllers {

    [self userInteracionEnabledOnViews:NO];
}

#pragma mark - Private Methods

- (void)animateIndicatorWithXPosition:(CGFloat)xPosition {

    [UIView animateWithDuration:0.2f animations:^{
        self.cstrViewIndicatorX.constant += xPosition;
        [self.view layoutIfNeeded];
    }
     completion:^(BOOL finished) {
         [self userInteracionEnabledOnViews:YES];
     }];
}

- (void)userInteracionEnabledOnViews:(BOOL)enable {

//    DDLogError(@"Status: %@", enable ? @"Liberado" : @"Blocked");
    self.viewButtons.userInteractionEnabled = enable;
    self.pageViewController.view.userInteractionEnabled = enable;
}

- (void)openLoginViewControllerWithError:(BOOL)showError {

    [self removeAutoRequestNotification];

    LoginViewController *loginView = [LoginViewController new];
    [self presentViewController:loginView animated:YES completion:^(void) {
        if (showError) {
            [[UIAlertView alertViewLoginFailed] show];
        }
    }];
}

- (void)removeAutoRequestNotification {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)moveToDayBasedOnDate {

    NSInteger todayDay = [GeneralHelper currentWeekDayNumber];

    todayDay = todayDay == 1 ? 0 : todayDay - 2;

    if (todayDay != 0) {
        [self setPageViewControllerHorarioViewWithDayId:todayDay
                                           andDirection:UIPageViewControllerNavigationDirectionForward];
    }
}

- (void)reloadFirstViewController {

    [self.horarioGenericViewFirst loadWithHorario:[self horarioForIndex:0]];
    [self.horarioGenericViewFirst reloadTableView];
}

- (void)reloadViewGenericWithId:(NSInteger)viewId {

    HorarioGenericViewController *horarioViewController = self.pageViewController.viewControllers[0];
    [horarioViewController loadWithHorario:[self horarioForIndex:viewId]];
    [horarioViewController reloadTableView];
    [horarioViewController stopRefreshing];
}

- (HorarioGenericViewController *)horarioGenericViewWithId:(NSInteger)viewId {

    HorarioGenericViewController *horarioViewController = [HorarioGenericViewController new];
    horarioViewController.delegate = self;

    horarioViewController.restorationIdentifier = fstr(@"%d",(int)viewId);

    [horarioViewController loadWithHorario:[self horarioForIndex:viewId]];
    
    return horarioViewController;
}

- (void)setPageViewControllerHorarioViewWithDayId:(NSInteger)dayId
                                     andDirection:(UIPageViewControllerNavigationDirection)direction {

    HorarioGenericViewController *horarioViewController = [self horarioGenericViewWithId:dayId];
    [self userInteracionEnabledOnViews:NO];

    /**
     *  Crash do crashlytics: https://fabric.io/mack-notas/ios/apps/caio-remedio.macknotas/issues/5575847bf505b5ccf012667a
     *  Discussões: http://stackoverflow.com/questions/20004310/invalid-parameter-exception-thrown-by-uiqueuingscrollview
     *  http://stackoverflow.com/questions/14220289/removing-a-view-controller-from-uipageviewcontroller
     */
    __weak typeof(self) weakSelf = self;

    [self.pageViewController setViewControllers:@[horarioViewController]
                                      direction:direction
                                       animated:YES
                                     completion:^(BOOL finished) {
                                         if (finished) {
                                             [weakSelf userInteracionEnabledOnViews:YES];
                                             dispatch_async(dispatch_get_main_queue(), ^{
                                                 [weakSelf.pageViewController
                                                  setViewControllers:@[horarioViewController]
                                                  direction:direction
                                                  animated:NO
                                                  completion:nil];
                                             });
                                         }
                                     }];

    if (dayId != 0) {
        if (self.lastBtnDay < dayId) {
            [self animateIndicatorWithXPosition:self.viewIndicator.frame.size.width * (dayId - self.lastBtnDay)];
        }
        else if (self.lastBtnDay > dayId) {
            [self animateIndicatorWithXPosition:-(self.viewIndicator.frame.size.width * (self.lastBtnDay - dayId))];
        }
    }

    self.lastBtnDay = dayId;
}

#pragma mark - Requests

- (void)requestReloadIgnoringCacheWithViewId:(NSInteger)viewId {

    [self verifyLoggedUserSkippingCache:YES withViewId:viewId];
}

- (void)requestHorariosSkippingCache:(BOOL)skippingCache
                          withViewId:(NSInteger)viewId {

    BOOL shouldUpdate = [DBManager shouldUpdateModel:NSStringFromClass([MNHorario class])
                                        withMappings:self.mappings];
    
    if (skippingCache || shouldUpdate) {
        [[ConnectionHelper sharedClient] requestHorariosWithBlockSuccess:^(NSURLSessionDataTask *task,
                                                                           id responseObject) {
            [ConnectionHelper stopActivityIndicator];
            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"login"] isEqual: @0]) {
                    DDLogError(@"User não logado - TIA Response: %@", responseObject[@"login"]);
                    [LocalUser logout];
                    [self openLoginViewControllerWithError:YES];
                    return;
                }

                [self saveUserHorarios:responseObject];

                if (responseObject[@"isInvalid"]) {
                    if ([responseObject[@"isInvalid"] boolValue]) {
                        [[UIAlertView alertViewWithCustomMessage:@"A sua grade horária ainda não está disponível."] show];
                    }
                }
                [self reloadViewGenericWithId:viewId];
            }

        } andBlockFailure:^(NSURLSessionDataTask *task, NSError *error) {
            
            [[ConnectionHelper sharedClient] handleConnectionError:error];
        }];
    }
}

- (void)verifyLoggedUserSkippingCache:(BOOL)skipCache
                           withViewId:(NSInteger)viewId {

    PFUser *currentUser = [PFUser currentUser];

    if (!currentUser) {
        [self openLoginViewControllerWithError:YES];
    }
    else {
        [self requestHorariosSkippingCache:skipCache
                                withViewId:viewId];
    }
}

#pragma mark - DB Methods

- (void)saveUserHorarios:(id)response {

    if (response[@"isInvalid"]) {
        if ([response[@"isInvalid"] boolValue]) {
            [MNHorario clearAllData];
        }
    }

    if (response[@"grade"]) {
        [MNHorario saveHorariosFromResponse:response[@"grade"]];
    }
}

- (MNHorario *)horarioForIndex:(NSUInteger)index {

    __block MNHorario *horario;

    [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction * transaction) {
            horario = [[transaction ext:MNHorarioViewName] objectAtRow:index
                                                             inSection:0
                                                          withMappings:self.mappings];
    }];

    return horario;
}

- (void)persistenceManagerDidUpdate:(NSNotification *)notification {

    NSArray *notifications = notification.userInfo[@"notifications"];
    NSArray *rowChanges = nil;

    [[[DBManager sharedInstance].uiConnection ext:MNHorarioViewName]
     getSectionChanges:nil
     rowChanges:&rowChanges
     forNotifications:notifications
     withMappings:self.mappings];

    if (rowChanges.count == 0) {
        return;
    }

    for (YapDatabaseViewRowChange *rowChange in rowChanges) {
        switch (rowChange.type) {

            case YapDatabaseViewChangeDelete :
            case YapDatabaseViewChangeInsert :
            case YapDatabaseViewChangeMove :
            case YapDatabaseViewChangeUpdate :
                [self reloadFirstViewController];
                break;
        }
    }
}

#pragma mark - Day Btns Event

/**
 *  0 = Seg
 *  5 = Sab
 *
 *  UIPageViewControllerNavigationDirectionForward
 *  UIPageViewControllerNavigationDirectionReverse
 */

- (IBAction)btnSegClick:(id)sender {

    if (self.lastBtnDay == 0) {
        return;
    }
    else {
        [self setPageViewControllerHorarioViewWithDayId:0
                                           andDirection:UIPageViewControllerNavigationDirectionReverse];
        [self animateIndicatorWithXPosition:-self.cstrViewIndicatorX.constant];
    }
}

- (IBAction)btnTerClick:(id)sender {

    if (self.lastBtnDay == 1) {
        return;
    }
    if (self.lastBtnDay < 1) {
        [self setPageViewControllerHorarioViewWithDayId:1
                                           andDirection:UIPageViewControllerNavigationDirectionForward];
    }
    else if (self.lastBtnDay > 1) {
        [self setPageViewControllerHorarioViewWithDayId:1
                                           andDirection:UIPageViewControllerNavigationDirectionReverse];
    }
}

- (IBAction)btnQuaClick:(id)sender {

    if (self.lastBtnDay == 2) {
        return;
    }
    if (self.lastBtnDay < 2) {
        [self setPageViewControllerHorarioViewWithDayId:2
                                           andDirection:UIPageViewControllerNavigationDirectionForward];
    }
    else if (self.lastBtnDay > 2) {
        [self setPageViewControllerHorarioViewWithDayId:2
                                           andDirection:UIPageViewControllerNavigationDirectionReverse];
    }
}

- (IBAction)btnQuiClick:(id)sender {

    if (self.lastBtnDay == 3) {
        return;
    }
    if (self.lastBtnDay < 3) {
        [self setPageViewControllerHorarioViewWithDayId:3
                                           andDirection:UIPageViewControllerNavigationDirectionForward];
    }
    else if (self.lastBtnDay > 3) {
        [self setPageViewControllerHorarioViewWithDayId:3
                                           andDirection:UIPageViewControllerNavigationDirectionReverse];
    }
}

- (IBAction)btnSexClick:(id)sender {

    if (self.lastBtnDay == 4) {
        return;
    }
    if (self.lastBtnDay < 4) {
        [self setPageViewControllerHorarioViewWithDayId:4
                                           andDirection:UIPageViewControllerNavigationDirectionForward];
    }
    else if (self.lastBtnDay > 4) {
        [self setPageViewControllerHorarioViewWithDayId:4
                                           andDirection:UIPageViewControllerNavigationDirectionReverse];
    }
}

- (IBAction)btnSabClick:(id)sender {

    if (self.lastBtnDay == 5) {
        return;
    }
    if (self.lastBtnDay < 5) {
        [self setPageViewControllerHorarioViewWithDayId:5
                                           andDirection:UIPageViewControllerNavigationDirectionForward];
    }
    else if (self.lastBtnDay > 5) {
        [self setPageViewControllerHorarioViewWithDayId:5
                                           andDirection:UIPageViewControllerNavigationDirectionReverse];
    }
}

#pragma mark - HorarioGenericViewDelegate

- (void)horarioGenericDidReloadViewId:(NSInteger)viewId {

    [self requestReloadIgnoringCacheWithViewId:viewId];
}

@end