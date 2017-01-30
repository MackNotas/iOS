//
//  AcViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 17/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "AcViewController.h"

/**
 *  Cells
 */
#import "AcCell.h"
#import "TotalHorasCell.h"

/**
 *  Controllers
 */
#import "SettingsViewController.h"
#import "LoginViewController.h"

/**
 *  Helpers
 */
#import "ConnectionHelper.h"
#import "UITableView+Helper.h"
#import "DBManager.h"

/**
 *  Models
 */
#import "MNAc+Persistence.h"

static NSString *kLoadingAC   = @"Carregando...";
static NSString *kEmptyAC     = @"Não há nenhuma atividade!";
static const CGFloat kShowMoreHeight = 151.0f;

@interface AcViewController ()

/**
 *  Arrays
 */
@property (nonatomic) NSArray *arraySectionTitles;

/**
 *  Yap Objects
 */
@property (nonatomic) YapDatabaseViewMappings *mappings;

/**
 Primitives
 */
@property (nonatomic) BOOL  shouldShowMore;
@property (nonatomic) BOOL  isMoreInfoVisible;
@property (nonatomic) int   rowToShowMore;

/**
 *  Barbuttom itens
 */
@property (nonatomic) UIBarButtonItem *barBtnRefresh;

@end

@implementation AcViewController

- (instancetype)init {

    self = [super initWithStyle:UITableViewStyleGrouped];

    if (self) {
        self.title = @"Ativ. Complem.";
        self.arraySectionTitles = @[@"Resumo de Horas",
                                    @"Atividades Deferidas"];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeAutoRequestNotification)
                                                     name:kSettingsViewControllerWillLogoutUserNotification
                                                   object:nil];

        self.tabBarItem.image = [UIImage imageNamed:@"icon_ac"];
        self.rowToShowMore = -1;

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(persistenceManagerDidUpdate:)
         name:DBManagerDidUpdateNotification
         object:[DBManager sharedInstance]];

        _mappings = [[YapDatabaseViewMappings alloc]initWithGroups:[MNAc groupsName]
                                                              view:MNACViewName];

        [[DBManager sharedInstance].uiConnection beginLongLivedReadTransaction];
        [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            [_mappings updateWithTransaction:transaction];
        }];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"defaultCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AcCell class])
                                               bundle:nil]
     
         forCellReuseIdentifier:@"fullCell"];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([TotalHorasCell class])
                                               bundle:nil]

         forCellReuseIdentifier:@"totalHorasCell"];

    self.navigationItem.rightBarButtonItem = self.barBtnRefresh;

    [self setupRefreshControl];

}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
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

    return AcSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return 5;
    }

    return self.shouldShowMore ? [self.mappings numberOfItemsInSection:AcSectionList]+1 : [self.mappings numberOfItemsInSection:AcSectionList];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell;
    MNAc *MNAC;

    if (indexPath.section == AcSectionList) {

        if (indexPath.row != self.rowToShowMore) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"defaultCell"
                                                   forIndexPath:indexPath];

            NSIndexPath *realIndexPath = (indexPath.row > self.rowToShowMore &&
                                          self.shouldShowMore) ? [NSIndexPath indexPathForRow:indexPath.row-1
                                                                                    inSection:indexPath.section] : indexPath;
            MNAC = [self acForIndexPath:realIndexPath];
            cell.textLabel.text = MNAC.assunto;
            cell.textLabel.numberOfLines = 0;
        }

        else {
            AcCell *acCell = [tableView dequeueReusableCellWithIdentifier:@"fullCell"
                                                             forIndexPath:indexPath];
            MNAC = [self acForIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1
                                                           inSection:indexPath.section]];

            [acCell loadWithAC:MNAC];

            cell = acCell;
        }
    }

    else if (indexPath.section == AcSectionTotalTime) {
        TotalHorasCell *totalHorasCell = [tableView dequeueReusableCellWithIdentifier:@"totalHorasCell"
                                                                         forIndexPath:indexPath];

        MNAC = [self acForIndexPath:[NSIndexPath indexPathForRow:0
                                                       inSection:indexPath.section]];

        [totalHorasCell loadWithAc:MNAC
                            andRow:indexPath.row];

        cell = totalHorasCell;
    }
    return cell;
}

#pragma mark - UITableView Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == AcSectionList &&
        [self.mappings numberOfItemsInGroup:MNACAtivDeferidasGroup] > 0) {
        [tableView beginUpdates];
        if (self.shouldShowMore) {
            if (indexPath.row == self.rowToShowMore - 1) {
                self.shouldShowMore = NO;
                self.isMoreInfoVisible = NO;
                self.rowToShowMore = -1;
                [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1
                                                                       inSection:AcSectionList]]
                                 withRowAnimation:UITableViewRowAnimationMiddle];
            }
            else {
                self.isMoreInfoVisible = YES;
                if (indexPath.row < self.rowToShowMore) {
                    self.rowToShowMore = (int)indexPath.row+1;
                }
                else {
                    self.rowToShowMore = (int)indexPath.row;
                }
                [tableView reloadSections:[NSIndexSet indexSetWithIndex:AcSectionList]
                         withRowAnimation:UITableViewRowAnimationFade];
                [self.refreshControl endRefreshing];
            }
        }
        else {

            self.rowToShowMore = (int)indexPath.row + 1;
            self.shouldShowMore = YES;
            self.isMoreInfoVisible = NO;
            [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.rowToShowMore
                                                                   inSection:AcSectionList]]
                             withRowAnimation:UITableViewRowAnimationMiddle];
        }

        [tableView endUpdates];
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.arraySectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row == self.rowToShowMore && indexPath.section == AcSectionList) {
        return kShowMoreHeight;
    }
    return CELL_DEFAULT_HEIGHT;
}

#pragma mark - Private Methods

- (MNAc *)acForIndexPath:(NSIndexPath *)indexPath {

    __block MNAc *MNAC;

    [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction * transaction) {
        MNAC = [[transaction ext:MNACViewName]
                objectAtIndexPath:indexPath
                withMappings:self.mappings];
    }];

    return MNAC;
}

- (void)setupRefreshControl {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(requestReloadIgnoringCache)
                  forControlEvents:UIControlEventValueChanged];
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

- (void)openLoginViewControllerWithError:(BOOL)showError {

    [self removeAutoRequestNotification];

    LoginViewController *loginView = [LoginViewController new];
    [self presentViewController:loginView animated:YES completion:^(void) {
        if (showError) {
            [[UIAlertView alertViewLoginFailed] show];
        }
    }];
}

- (void)verifyLoggedUserSkippingCache:(BOOL)skippingCache {

    PFUser *currentUser = [PFUser currentUser];

    if (!currentUser) {
        [self openLoginViewControllerWithError:NO];
    }
    else {
        [self requestACSkippingCache:skippingCache];
    }
}

- (void)removeAutoRequestNotification {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
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

#pragma mark - Request

- (void)requestReloadIgnoringCache {

    [self verifyLoggedUserSkippingCache:YES];
}

- (void)requestACSkippingCache:(BOOL)shouldSkipCache {

    BOOL shouldUpdate = [DBManager shouldUpdateModel:NSStringFromClass([MNAc class])
                                        withMappings:self.mappings];

    if (shouldSkipCache || shouldUpdate) {

        [self shouldStartRefreshingItems:YES];

        [[ConnectionHelper sharedClient] requestACWithBlockSuccess:^(NSURLSessionDataTask *task, id responseObject) {

            [ConnectionHelper stopActivityIndicator];

            if ([responseObject isKindOfClass:[NSDictionary class]]) {
                if ([responseObject[@"login"] isEqual: @0]) {
                    DDLogError(@"User não logado - TIA Response: %@", responseObject[@"login"]);
                    [LocalUser logout];
                    [self openLoginViewControllerWithError:NO];
                }
                else {
                    [self saveUserAC:responseObject];
                }
            }
            [self shouldStartRefreshingItems:NO];
        } andBlockFailure:^(NSURLSessionDataTask *task, NSError *error) {

            [self shouldStartRefreshingItems:NO];
        }];
    }
}

#pragma mark - Database Methods

- (void)saveUserAC:(id)responseObject {

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if (responseObject[@"isInvalid"]) {
            return;
        }
    }

    [MNAc saveACFromResponse:responseObject];
}

- (void)persistenceManagerDidUpdate:(NSNotification *)notification {

    NSArray *notifications = notification.userInfo[@"notifications"];

    NSArray *rowChanges = nil;

    [[[DBManager sharedInstance].uiConnection ext:MNACViewName]
     getSectionChanges:nil
     rowChanges:&rowChanges
     forNotifications:notifications
     withMappings:self.mappings];

    if (rowChanges.count == 0) {
        return;
    }

    [self.tableView beginUpdates];

    if (rowChanges.count > 0) {
        for (YapDatabaseViewRowChange *rowChange in rowChanges) {

            if ([rowChange.finalGroup isEqualToString:MNACTotalHorasGroup]) {
                if (rowChange.type == YapDatabaseViewChangeUpdate ||
                    rowChange.type == YapDatabaseViewChangeInsert) {
                    [self.tableView reloadSection:AcSectionTotalTime
                                 withRowAnimation:UITableViewRowAnimationFade];
                }
            }
            else if ([rowChange.originalGroup isEqualToString:MNACTotalHorasGroup] &&
                     rowChange.type == YapDatabaseViewChangeDelete) {
                continue;
            }

            else {
                switch (rowChange.type) {

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
        }
    }
    
    [self.tableView endUpdates];
}

@end
