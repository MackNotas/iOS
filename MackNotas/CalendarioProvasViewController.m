//
//  CalendarioProvasViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 30/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "CalendarioProvasViewController.h"

/**
 Views
 */
#import "MonthHeader.h"
#import "LoginViewController.h"
#import "SettingsViewController.h"

/**
 Cells
 */
#import "CalendarItemCell.h"

/**
 *  Helpers
 */
#import "ConnectionHelper.h"
#import "DBManager.h"

/**
 *  Models
 */
#import "MNCalendario+Persistence.h"

@interface CalendarioProvasViewController ()

/**
 *  Barbuttom itens
 */
@property (nonatomic) UIBarButtonItem *barBtnRefresh;

/**
 *  JSON Array
 */
//@property (nonatomic) NSMutableArray    *calProvasArray;

/**
 Primitives
 */
@property (nonatomic) BOOL isOnFirstSemester;

/**
 *  Yap Objects
 */
@property (nonatomic) YapDatabaseViewMappings *mappings;

@end

@implementation CalendarioProvasViewController

- (instancetype)init {

    self = [super initWithStyle:UITableViewStylePlain];

    if (self) {
        self.title = @"Calendário";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_calendario"];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeAutoRequestNotification)
                                                     name:kSettingsViewControllerWillLogoutUserNotification
                                                   object:nil];
        _isOnFirstSemester = [GeneralHelper isOnFirstSemester];

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(persistenceManagerDidUpdate:)
         name:DBManagerDidUpdateNotification
         object:[DBManager sharedInstance]];

        _mappings = [[YapDatabaseViewMappings alloc]initWithGroups:[MNCalendario groupsName]
                                                              view:MNCalendarioViewName];

        [[DBManager sharedInstance].uiConnection beginLongLivedReadTransaction];
        [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            [_mappings updateWithTransaction:transaction];
        }];
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MonthHeader class])
                                               bundle:nil]
forHeaderFooterViewReuseIdentifier:NSStringFromClass([MonthHeader class])];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([CalendarItemCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([CalendarItemCell class])];

    self.tableView.separatorColor = [UIColor clearColor];

    self.navigationItem.rightBarButtonItem = self.barBtnRefresh;
    [self setupRefreshControl];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];

    if ([self.mappings numberOfItemsInAllGroups] > 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSInteger currentMonth = [GeneralHelper currentMonthForArray];

            [self.tableView scrollToRowAtIndexPath:
             [NSIndexPath indexPathForRow:NSNotFound
                                inSection:currentMonth]
                                  atScrollPosition:UITableViewScrollPositionTop
                                          animated:YES];
        });
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [GAHelper trackViewWithName:NSStringFromClass(self.class)];
    [self verifyLoggedUserSkippingCache:NO];
}

- (void)viewWillDisappear:(BOOL)animated {

    [super viewWillDisappear:animated];
    [self removeAutoRequestNotification];
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {

    [self verifyLoggedUserSkippingCache:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.isOnFirstSemester ? 7 : 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.mappings numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    CalendarItemCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([CalendarItemCell class])
                                                             forIndexPath:indexPath];
    MNCalendario *calendario = [self calendarioForIndexPath:indexPath];
    [cell loadWithCalendario:calendario];

    return cell;
}

#pragma mark - UITableView Delegate

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section {

    MonthHeader *view = [tableView dequeueReusableHeaderFooterViewWithIdentifier:NSStringFromClass([MonthHeader class])];

    if (self.isOnFirstSemester) {
        [view loadWithMonthNumber:section];
    }
    else {
        [view loadWithMonthNumber:section + 7];
    }
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {

    return [MonthHeader viewHeight];
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [CalendarItemCell height];
}

#pragma mark - Private Methods

- (void)openLoginViewControllerWithError:(BOOL)showError {

    [self removeAutoRequestNotification];

    LoginViewController *loginView = [LoginViewController new];
    [self presentViewController:loginView animated:YES completion:^(void) {
        if (showError) {
            [[UIAlertView alertViewLoginFailed] show];
        }
    }];
}

- (void)setupRefreshControl {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(requestReloadIgnoringCache)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)removeAutoRequestNotification {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

- (void)shouldStartRefreshingItems:(BOOL)shouldStart {

    if (shouldStart) {
        self.barBtnRefresh.enabled = NO;

        [GeneralHelper showActivityIndicatorOnNavBarRight:YES
                                        WithRefreshButton:self.barBtnRefresh
                                        andNavigationItem:self.navigationItem];
    }
    else {
        self.barBtnRefresh.enabled = YES;
        [GeneralHelper showActivityIndicatorOnNavBarRight:NO
                                        WithRefreshButton:self.barBtnRefresh
                                        andNavigationItem:self.navigationItem];
        [self.refreshControl endRefreshing];
    }
    
}

#pragma mark - Database Methods

- (MNCalendario *)calendarioForIndexPath:(NSIndexPath *)indexPath {

    __block MNCalendario *calendario;

    [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction * transaction) {
        calendario = [[transaction ext:MNCalendarioViewName]
                      objectAtIndexPath:indexPath
                      withMappings:self.mappings];
    }];

    return calendario;
}

- (void)persistenceManagerDidUpdate:(NSNotification *)notification {

    NSArray *notifications = notification.userInfo[@"notifications"];

    NSArray *rowChanges = nil;
    NSArray *sectionChanges = nil;

    [[[DBManager sharedInstance].uiConnection ext:MNCalendarioViewName]
     getSectionChanges:&sectionChanges
     rowChanges:&rowChanges
     forNotifications:notifications
     withMappings:self.mappings];

    if (rowChanges.count == 0 && sectionChanges.count == 0) {
        return;
    }

    [self.tableView beginUpdates];

    for (YapDatabaseViewSectionChange *sectionChange in sectionChanges)
    {
        switch (sectionChange.type)
        {
            case YapDatabaseViewChangeDelete :
            {
                [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeInsert :
            {
                [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionChange.index]
                              withRowAnimation:UITableViewRowAnimationAutomatic];
                break;
            }
            case YapDatabaseViewChangeMove:
            case YapDatabaseViewChangeUpdate:
                break;
        }
    }

    for (YapDatabaseViewRowChange *rowChange in rowChanges) {

        switch (rowChange.type)
        {
            case YapDatabaseViewChangeDelete : {

                [self.tableView
                 deleteRowsAtIndexPaths:@[ rowChange.indexPath ]
                 withRowAnimation:UITableViewRowAnimationAutomatic];

                break;
            }
            case YapDatabaseViewChangeInsert : {

                [self.tableView
                 insertRowsAtIndexPaths:@[ rowChange.newIndexPath ]
                 withRowAnimation:UITableViewRowAnimationAutomatic];

                break;
            }

            case YapDatabaseViewChangeMove : {

                [self.tableView
                 deleteRowsAtIndexPaths:@[ rowChange.indexPath ]
                 withRowAnimation:UITableViewRowAnimationAutomatic];

                [self.tableView
                 insertRowsAtIndexPaths:@[ rowChange.newIndexPath ]
                 withRowAnimation:UITableViewRowAnimationAutomatic];

                break;
            }

            case YapDatabaseViewChangeUpdate : {

                [self.tableView reloadRowsAtIndexPaths:@[ rowChange.indexPath ]
                                      withRowAnimation:UITableViewRowAnimationNone];
                break;
            }
        }
    }

    [self.tableView endUpdates];
}

- (void)saveUserCalendarioWithResponse:(id)responseObject {

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if (responseObject[@"isInvalid"]) {
            return;
        }
    }

    [MNCalendario saveCalendarioFromResponse:responseObject];
}

#pragma mark - Requests

- (void)verifyLoggedUserSkippingCache:(BOOL)skipCache {

    PFUser *currentUser = [PFUser currentUser];

    if (!currentUser) {
        [self openLoginViewControllerWithError:NO];
    }
    else {
        [self requestCalSkippingCache:skipCache];
    }
}

- (void)requestCalSkippingCache:(BOOL)skipCache {

    BOOL shouldUpdate = [DBManager shouldUpdateModel:NSStringFromClass([MNCalendario class])
                                        withMappings:self.mappings];
    if (skipCache || shouldUpdate) {

        [self shouldStartRefreshingItems:YES];

        [[ConnectionHelper sharedClient] requestCalendarioWithBlockSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            [ConnectionHelper stopActivityIndicator];

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"login"] isEqual: @0]) {
                    DDLogError(@"User não logado - TIA Response: %@", responseObject[@"login"]);
                    [LocalUser logout];
                    [self openLoginViewControllerWithError:NO];
                }
            }
            else if ([responseObject isKindOfClass:[NSArray class]]) {
                [self saveUserCalendarioWithResponse:responseObject];
            }

            [self shouldStartRefreshingItems:NO];

        } andBlockFailure:^(NSURLSessionDataTask *task, NSError *error) {

            [self shouldStartRefreshingItems:NO];
        }];
    }
}

- (void)requestReloadIgnoringCache {

    [self verifyLoggedUserSkippingCache:YES];
}

#pragma mark - Properties Override

- (UIBarButtonItem *)barBtnRefresh {

    if (_barBtnRefresh) {
        return _barBtnRefresh;
    }

    _barBtnRefresh = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                                                                   target:self
                                                                   action:@selector(requestReloadIgnoringCache)];
    _barBtnRefresh.tintColor = [UIColor whiteColor];

    return _barBtnRefresh;
}

@end
