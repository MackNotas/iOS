//
//  NotasViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 17/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "NotasViewController.h"

/**
 *  Objects
 */
#import "AFHTTPRequestOperationManager.h"
#import "LocalUser.h"

/**
 *  Cells
 */
#import "NotasTableViewCell.h"
#import "EmNotasTableViewCell.h"
#import "MateriaCell.h"

/**
 *  Controllers
 */
#import "SettingsViewController.h"
#import "LoginViewController.h"
#import "DesempenhoViewController.h"

/**
 *  Models
 */
#import "MNNota+Persistence.h"
#import "MNFalta+Persistence.h"

/**
 *  Helpers
 */
#import "ConnectionHelper.h"

@interface NotasViewController ()

/**
 *  Arrays
 */

@property (nonatomic) NSMutableArray *arrayJSONNotas;
//@property (nonatomic) NSMutableArray *arrayJSONFaltas;

/**
 *  Yap Objects
 */
@property (nonatomic) YapDatabaseViewMappings *mappings;

/**
 *  Barbuttom itens
 */
@property (nonatomic) UIBarButtonItem *barBtnRefresh;
@property (nonatomic) UIBarButtonItem *barBtnDesempenho;

/**
 Primitives
 */
@property (nonatomic) BOOL shouldShowNotas;
@property (nonatomic) BOOL isNotaVisible;

@property (nonatomic) BOOL isFaltasInvalid;
@property (nonatomic) BOOL isNotasInvalid;

@property (nonatomic) int rowToShowNota;

@end

@implementation NotasViewController

- (instancetype)init {

    self = [super initWithStyle:UITableViewStylePlain];
    if (self) {
        self.title = @"Matérias";
        self.tabBarItem.image = [UIImage imageNamed:@"icon_materias"];
        _rowToShowNota = -1;

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(removeAutoRequestNotification)
                                                     name:kSettingsViewControllerWillLogoutUserNotification
                                                   object:nil];

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(persistenceManagerDidUpdate:)
         name:DBManagerDidUpdateNotification
         object:[DBManager sharedInstance]];

        _mappings = [[YapDatabaseViewMappings alloc]initWithGroups:@[MNotaGroupName]
                                                              view:MNotaViewName];

        [[DBManager sharedInstance].uiConnection beginLongLivedReadTransaction];
        [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction *transaction) {
            [_mappings updateWithTransaction:transaction];
        }];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView
     registerClass:[UITableViewCell class]
     forCellReuseIdentifier:@"cellMateria"];

    if ([[LocalUser sharedInstance] isEnsinoMedio]) {
        [self.tableView
         registerNib:[UINib nibWithNibName:NSStringFromClass([EmNotasTableViewCell class])
                                    bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([EmNotasTableViewCell class])];
    }
    else {
        [self.tableView
         registerNib:[UINib nibWithNibName:NSStringFromClass([NotasTableViewCell class])
                                    bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([NotasTableViewCell class])];
        [self.tableView
         registerNib:[UINib nibWithNibName:NSStringFromClass([MateriaCell class])
                                    bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MateriaCell class])];
    }

    self.navigationItem.rightBarButtonItem = self.barBtnRefresh;

//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8")) {
//        self.navigationItem.leftBarButtonItem = self.barBtnDesempenho;  
//    }

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)applicationDidBecomeActive:(NSNotification *)notification {

    [self verifyLoggedUserSkippingCache:NO];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.shouldShowNotas ? [self.mappings numberOfItemsInSection:section]+1 : [self.mappings numberOfItemsInSection:section];
}

#pragma mark - UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row != self.rowToShowNota) {
        MateriaCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MateriaCell class]) forIndexPath:indexPath];
        return cell;
    }

    else {

        if (![[LocalUser sharedInstance] isEnsinoMedio]) {
            NotasTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([NotasTableViewCell class])
                                                                       forIndexPath:indexPath];

            return cell;
        }
        else {
            EmNotasTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([EmNotasTableViewCell class])
                                                                         forIndexPath:indexPath];
            return cell;
        }
    }
    
    return nil;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

    MNNota *nota;

    if (indexPath.row != self.rowToShowNota) {

        if (indexPath.row > self.rowToShowNota &&
            self.shouldShowNotas) {

            nota = [self notaForIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1
                                                             inSection:indexPath.section]];
        }
        else {
            nota = [self notaForIndexPath:indexPath];
        }

        [(MateriaCell *)cell load:nota];
    }

    else {
        NSIndexPath *expandIndexPath = [NSIndexPath indexPathForRow:self.rowToShowNota-1
                                                          inSection:indexPath.section];

        if (![[LocalUser sharedInstance] isEnsinoMedio]) {
            nota = [self notaForIndexPath:expandIndexPath];
            [(NotasTableViewCell *)cell loadWithNota:nota];
        }
        else {
            nota = [self notaForIndexPath:expandIndexPath];
            [(EmNotasTableViewCell *)cell loadWithNota:nota];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (!self.shouldShowNotas) {
        return [MateriaCell sizeForNota:[self notaForIndexPath:indexPath]];
    }

    if (indexPath.row == self.rowToShowNota) {
        return [NotasTableViewCell size];
    }

    if (indexPath.row > self.rowToShowNota) {
        return [MateriaCell sizeForNota:[self notaForIndexPath:[NSIndexPath indexPathForRow:indexPath.row-1
                                                                                  inSection:indexPath.section]]];
    }

    return [MateriaCell sizeForNota:[self notaForIndexPath:indexPath]];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [tableView beginUpdates];
    if (self.shouldShowNotas) {
        if (indexPath.row == self.rowToShowNota - 1) {
            self.shouldShowNotas = NO;
            self.isNotaVisible = NO;
            self.rowToShowNota = -1;
            [tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:indexPath.row+1 inSection:0]]
                             withRowAnimation:UITableViewRowAnimationMiddle];
        }
        else {
            self.isNotaVisible = YES;
            if (indexPath.row < self.rowToShowNota) {
                self.rowToShowNota = (int)indexPath.row+1;
            }
            else {
                self.rowToShowNota = (int)indexPath.row;
            }
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:0]
                     withRowAnimation:UITableViewRowAnimationFade];
            [self.refreshControl endRefreshing];
        }
    }
    else {

        self.rowToShowNota = (int)indexPath.row + 1;
        self.shouldShowNotas = YES;
        self.isNotaVisible = NO;
        [tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.rowToShowNota inSection:0]]
                         withRowAnimation:UITableViewRowAnimationMiddle];
    }

    [tableView endUpdates];
    if (self.rowToShowNota != -1) {
        [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.rowToShowNota-1 inSection:0]
                         atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
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

- (UIBarButtonItem *)barBtnDesempenho {

    if (_barBtnDesempenho) {
        return _barBtnDesempenho;
    }

    _barBtnDesempenho = [[UIBarButtonItem alloc] initWithTitle:@"Desempenho"
                                                         style:UIBarButtonItemStylePlain
                                                        target:self
                                                        action:@selector(openDesempenho)];
    return _barBtnDesempenho;
}

#pragma mark - Request Methods

- (void)requestNotasSkippingCache:(BOOL)skippingCache {

    BOOL shouldUpdate = [DBManager shouldUpdateModel:NSStringFromClass([MNNota class])
                                        withMappings:self.mappings];

    if (skippingCache || shouldUpdate) {

        [self shouldStartRefreshingItems:YES];

        [[ConnectionHelper sharedClient]
         requestNotasWithBlockSuccess:^(NSURLSessionDataTask *task, id responseObject) {

             [ConnectionHelper stopActivityIndicator];

             if (responseObject) {
                 if ([responseObject isKindOfClass:[NSDictionary class]]) {
                     if ([responseObject[@"login"] isEqual: @0]) {
                         DDLogError(@"User não logado - TIA Response: %@", responseObject[@"login"]);
                         [LocalUser logout];
                         [self openLoginViewControllerWithError:NO];
                     }
                 }
                 else {
                     [self saveUserNotas:responseObject];

                     [self requestFaltasSkippingCache:skippingCache];
                 }
                 [self shouldStartRefreshingItems:NO];
             }
         } andBlockFailure:^(NSURLSessionDataTask *task, NSError *error) {

             [self shouldStartRefreshingItems:NO];
         }];
    }
}

- (void)requestFaltasSkippingCache:(BOOL)cache {

    if (![LocalUser sharedInstance].isEnsinoMedio) {
        [[ConnectionHelper sharedClient] requestFaltasWithBlockSuccess:^(NSURLSessionDataTask *task, id responseObject) {
            [ConnectionHelper stopActivityIndicator];

            [self saveUserFaltas:responseObject];
        }
                                                       andBlockFailure:nil];
    }
}

- (void)requestReloadIgnoringCache {

    [self verifyLoggedUserSkippingCache:YES];
}

- (void)verifyLoggedUserSkippingCache:(BOOL)skippingCache {

    PFUser *currentUser = [PFUser currentUser];

    if (!currentUser) {
        [self openLoginViewControllerWithError:NO];
    }
    else {
        [self requestNotasSkippingCache:skippingCache];
    }
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

- (void)saveUserFaltas:(id)responseObject {

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if (responseObject[@"isInvalid"]) {
            [MNFalta removeAll];
            return;
        }
    }

    [MNFalta saveFaltasFromResponse:responseObject];
}

- (void)saveUserNotas:(id)responseObject {

    if ([responseObject isKindOfClass:[NSDictionary class]]) {
        if (responseObject[@"isInvalid"]) {
            return;
        }
    }

    [MNNota saveNotasFromResponseArray:responseObject];
    self.arrayJSONNotas = responseObject;

    /**
     *  Crash encontrado no Crashlytics: User da logoff enquanto salva
     */
    PFUser *currentUser = [PFUser currentUser];

    if (currentUser && [LocalUser sharedInstance].hasPush) {

        PFQuery *query = [PFQuery queryWithClassName:@"Notas"];
        [query whereKey:@"user" equalTo:[PFUser currentUser]];
        [query findObjectsInBackgroundWithBlock:^(NSArray * objects, NSError * error) {
            if (!error) {
                PFObject *notas_object;

                /**
                 *  Crash encontrado no Crashlytics: Objects vem nill
                 */
                if (objects) {
                    if (objects.count > 0) {
                        notas_object = [objects firstObject];
                    }
                    else {
                        notas_object = [PFObject objectWithClassName:@"Notas"];
                    }
                }
                else if (!objects) {
                    notas_object = [PFObject objectWithClassName:@"Notas"];
                }
                notas_object[@"notaJson"] = [GeneralHelper decodeJSON:self.arrayJSONNotas];
                notas_object[@"user"] = [PFUser currentUser];
                [notas_object saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                    if (succeeded) {
                        DDLogDebug(@"User JSON salvo!");
                    }
                    else {
                        [[UIAlertView alertViewAllFailedWithError:error] show];
                    }
                }];
            }
            else {
                [[UIAlertView alertViewAllFailedWithError:error] show];
            }
        }];
    }
}

- (void)persistenceManagerDidUpdate:(NSNotification *)notification {

    NSArray *notifications = notification.userInfo[@"notifications"];

    NSArray *notaRowChanges = nil;

    [[[DBManager sharedInstance].uiConnection ext:MNotaViewName]
     getSectionChanges:nil
     rowChanges:&notaRowChanges
     forNotifications:notifications
     withMappings:self.mappings];

    if (notaRowChanges.count == 0) {
        return;
    }

    [self.tableView beginUpdates];

    if (notaRowChanges.count > 0) {
        for (YapDatabaseViewRowChange *rowChange in notaRowChanges) {
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

    [self.tableView endUpdates];
}

- (MNNota *)notaForIndexPath:(NSIndexPath *)indexPath {

    __block MNNota *nota;

    [[DBManager sharedInstance].uiConnection readWithBlock:^(YapDatabaseReadTransaction * transaction) {
        nota = [[transaction ext:MNotaViewName] objectAtIndexPath:indexPath
                                                     withMappings:self.mappings];
    }];

    return nota;
}

#pragma mark - Private Methods

- (void)openDesempenho {

    [self.navigationController pushViewController:[DesempenhoViewController new] animated:YES];
}

- (BOOL)isUserMediaGreen:(NSDictionary *)arrayNotas {

    if ([LocalUser sharedInstance].isEnsinoMedio) {
        return NO;
    }

    if (arrayNotas[@"MF"] && ([arrayNotas[@"MF"] floatValue] >= 6.0f
                              || [arrayNotas[@"MF"] isEqualToString:@"Aprovado"])) {
        return YES;
    }

    return NO;
}

/**
    DEPRECATED! As notas agora são enviadas normalmente.
 */
- (NSString *)userJSONToString {
    /**
     *  Deep Copy!
     */
    NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject:self.arrayJSONNotas];
    NSMutableArray *arrayJSON_copy = [NSKeyedUnarchiver unarchiveObjectWithData:buffer];

    for (int i = 0; i < arrayJSON_copy.count; i++) {
        NSDictionary *dic = arrayJSON_copy[i];

        for (int j = 0; j < [dic[@"notas"] count]; j++) {
            NSString *nota = dic[@"notas"][j];
            if (![nota isEqualToString:@""]) {
                arrayJSON_copy[i][@"notas"][j] = @"X";
            }
        }
    }

    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:arrayJSON_copy
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *json_stringfied = [[NSString alloc] initWithData:jsonData
                                                    encoding:NSUTF8StringEncoding];

    return json_stringfied;
}

- (void)removeAutoRequestNotification {

    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIApplicationDidBecomeActiveNotification
                                                  object:nil];
}

@end
