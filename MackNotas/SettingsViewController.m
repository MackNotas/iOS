//
//  SettingsViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 29/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "SettingsViewController.h"

/**
 *  Objects
 */
#import "LocalUser.h"

/**
 *  Cells
 */
#import "ServerStatusCell.h"
#import "GenericSwitchCell.h"

/**
 *  Views
 */
#import "SobreViewController.h"
#import "ConvidarAmigoViewController.h"
#import "WebViewController.h"
#import "LoginViewController.h"
#import "FeedbackMenuView.h"
#import "FeedbackFormViewController.h"
#import "BlurView.h"
#import "AdminPanelViewController.h"

/**
 *  Helpers
 */
#import "ConnectionHelper.h"
#import "FTHTTPCodes.h"
#import "UIView+MackNotas.h"
#import "DBManager.h"
#import "UITableView+Helper.h"

/**
 Notification
 */
NSString * const kSettingsViewControllerWillLogoutUserNotification = @"SettingsViewControllerWillLogout";
NSString * const kSettingsViewControllerDidLoginUserNotification = @"SettingsViewControllerDidLogin";

/**
 *  Cell text
 */
NSString *const kCellTextNotificationInvite = @"Convidar para receber notificação";
NSString *const kCellTextNotificationNoPush = @"Como posso ativar notificações?";

@interface SettingsViewController () < UITableViewDataSource, UITableViewDelegate, FeedbackMenuDelegate, BlurViewDelegate>

/**
 *  Views
 */
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic) BlurView *viewBlur;
@property (nonatomic) FeedbackMenuView *viewFeedBack;
@property (nonatomic) UIView *viewFeedbackBg;

/**
 Arrays
 */

@property (nonatomic) NSArray *arraySectionTitles;
@property (nonatomic) NSArray *arrayCellContactTitles;

/**
 Primitives
 */
@property (nonatomic) BOOL isTiaOnline;
@property (nonatomic) BOOL isWSOnline;
@property (nonatomic) BOOL isWSPushOnline;

@property (nonatomic) BOOL hasReloadedTia;
@property (nonatomic) BOOL hasReloadedWS;
@property (nonatomic) BOOL hasReloadedWSPush;

@property (nonatomic, readonly) BOOL hasPush;

@end

@implementation SettingsViewController

- (instancetype)init {

    self = [super initWithNibName:NSStringFromClass(self.class)
                           bundle:nil];

    if (self) {
        self.title = @"Ajustes";
        self.arrayCellContactTitles = @[@"Fale com o MackNotas",
//                                        @"Convidar para o app",
                                        @"Avisos e novidades",
//                                        @"Política de Privacidade",
                                        @"Sobre o MackNotas"];
        self.tabBarItem.image = [UIImage imageNamed:@"icon_settings"];

        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(reloadTableView)
                                                     name:kSettingsViewControllerDidLoginUserNotification
                                                   object:nil];
    }

    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"ordinaryCell"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([ServerStatusCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([ServerStatusCell class])];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([GenericSwitchCell class]) bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([GenericSwitchCell class])];

    [self requestServersStatusForRow:SettingsServerStatusRowTIA];
    [self requestServersStatusForRow:SettingsServerStatusRowWS];
    [self requestServersStatusForRow:SettingsServerStatusRowWSPush];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [GAHelper trackViewWithName:NSStringFromClass(self.class)];

    /**
     *  Precisa estar no viewWillAppear, pois se o usuario logar e abrir a tela na hora
     *  o CurrentUser vem nil
     */
    self.arraySectionTitles = @[fstr(@"TIA CONECTADO: %@", [LocalUser sharedInstance].tia),
                                @"STATUS DOS SERVIDORES",
                                @"NOTIFICAÇÕES",
                                @"INFORMAÇÕES"];
}

- (void)viewDidAppear:(BOOL)animated {

    [super viewDidAppear:animated];

    [self updateCurrentUserAndReload];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties Override

- (BOOL)hasPush {

    return [[[PFUser currentUser] objectForKey:@"hasPush"] boolValue];
}

- (BlurView *)viewBlur {

    if (_viewBlur) {
        return _viewBlur;
    }

    _viewBlur = [BlurView new];
    _viewBlur.translatesAutoresizingMaskIntoConstraints = NO;
    _viewBlur.delegate = self;

    return _viewBlur;
}

- (UIView *)viewFeedbackBg {

    if (_viewFeedbackBg) {
        return _viewFeedbackBg;
    }

    _viewFeedbackBg = [[UIView alloc] initWithFrame:CGRectZero];
    _viewFeedbackBg.backgroundColor = [UIColor clearColor];
    [_viewFeedbackBg addSubviewAndFillWithContent:self.viewBlur];

    self.viewFeedBack = [FeedbackMenuView new];

    self.viewFeedBack.translatesAutoresizingMaskIntoConstraints = NO;
    self.viewFeedBack.delegate = self;

    [_viewFeedbackBg addSubview:self.viewFeedBack];

    [_viewFeedbackBg addConstraint:[NSLayoutConstraint constraintWithItem:self.viewFeedBack
                                                                    attribute:NSLayoutAttributeCenterX
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_viewFeedbackBg
                                                                    attribute:NSLayoutAttributeCenterX
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];

    [_viewFeedbackBg addConstraint:[NSLayoutConstraint constraintWithItem:self.viewFeedBack
                                                                    attribute:NSLayoutAttributeCenterY
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:_viewFeedbackBg
                                                                    attribute:NSLayoutAttributeCenterY
                                                                   multiplier:1.0f
                                                                     constant:0.0f]];

    [_viewFeedbackBg addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-45-[viewFeedBack]-45-|"
                                                                                options:0
                                                                                metrics:nil
                                                                              views:@{@"viewFeedBack" : self.viewFeedBack}]];

    return _viewFeedbackBg;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return SettingsSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == SettingsSectionLogout) {
        return [[PFUser currentUser][@"isAdmin"] boolValue] ? 2 : 1;
    }
    else if (section == SettingsSectionServerStatus) {
        return self.hasPush ? SettingsServerStatusRowCount : SettingsServerStatusRowCount - 1;
    }
    else if (section == SettingsSectionNotification) {
        return self.hasPush ? SettingsNotificationRowCount : 1;
    }
    else if (section == SettingsSectionContact) {
        return SettingsContactRowCount;
    }
    return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.arraySectionTitles[section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == SettingsSectionLogout) {
        if (indexPath.row == 0) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordinaryCell"
                                                                    forIndexPath:indexPath];
            cell.textLabel.text = @"Sair";
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordinaryCell"
                                                                    forIndexPath:indexPath];
            cell.textLabel.text = @"Painel Admin";
            return cell;
        }
    }

    else if (indexPath.section == SettingsSectionServerStatus) {
        ServerStatusCell *cell = (ServerStatusCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([ServerStatusCell class])
                                                                   forIndexPath:indexPath];
        if (indexPath.row == SettingsServerStatusRowTIA) {
            [cell loadWithServerStatus:self.isTiaOnline
                        andTitleForRow:indexPath.row
                           hasReloaded:self.hasReloadedTia];
        }
        else if (indexPath.row == SettingsServerStatusRowWS) {
            [cell loadWithServerStatus:self.isWSOnline
                        andTitleForRow:indexPath.row
                           hasReloaded:self.hasReloadedWS];
        }
        else if (indexPath.row == SettingsServerStatusRowWSPush) {
            [cell loadWithServerStatus:self.isWSPushOnline
                        andTitleForRow:indexPath.row
                           hasReloaded:self.hasReloadedWSPush];
        }
        return cell;
    }

    else if (indexPath.section == SettingsSectionNotification) {

        if (indexPath.row == SettingsNotificationRowInvite ||
            (!self.hasPush && indexPath.row == 0)) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordinaryCell"
                                                                    forIndexPath:indexPath];
            cell.textLabel.text = self.hasPush ? kCellTextNotificationInvite : kCellTextNotificationNoPush;
            cell.textLabel.textColor = [UIColor redColor];

            return cell;
        }

        GenericSwitchCell *cell = (GenericSwitchCell *)[tableView dequeueReusableCellWithIdentifier:NSStringFromClass([GenericSwitchCell class])
                                                                                       forIndexPath:indexPath];
        [cell loadWithTitleForRow:indexPath.row
                        andTarget:self];
        return cell;
    }
    
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ordinaryCell" forIndexPath:indexPath];
        cell.textLabel.text = self.arrayCellContactTitles[indexPath.row];
        if (indexPath.row == SettingsContactRowContact) {
            cell.textLabel.textColor = [UIColor blueColor];
        }
        else {
            cell.textLabel.textColor = [UIColor blackColor];
        }
        return cell;
    }
    
    return nil;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == SettingsSectionLogout) {
        if (indexPath.row == 0) {
            [ConnectionHelper stopActivityIndicator];
            [[ConnectionHelper sharedClient] cancelAllRequests];

            [self logoutCurrentUser];
        }
        else if (indexPath.row == 1) {
            AdminPanelViewController *panelController = [AdminPanelViewController new];
            [self.navigationController pushViewController:panelController
                                                 animated:YES];
        }
    }
    else if (indexPath.section == SettingsSectionNotification) {
        if (indexPath.row == SettingsNotificationRowInvite) {
            ConvidarAmigoViewController *viewConvidar = [ConvidarAmigoViewController new];
            
            [self.navigationController pushViewController:viewConvidar
                                                 animated:YES];
        }
        else if (indexPath.row == 0 && ![LocalUser sharedInstance].hasPush) {
            [[[UIAlertView alloc] initWithTitle:@"Como ativar notificações?"
                                       message:@"Atualmente o nosso sistema de envio de notificações está em fase de testes"
                                                " e restrito a um pequeno número de usuários."
                                                "\n\nVocê pode, no entanto, ser convidado por algum usuário tester que possua a função ativa."
                                                "\n\nDe tempos em tempos faremos divulgações em nossa página do Facebook convidando"
                                                " interessados em participar. Fique ligado!"
                                       delegate:nil
                              cancelButtonTitle:@"Fechar"
                              otherButtonTitles:nil] show];
        }
    }
    else if (indexPath.section == SettingsSectionContact) {
        if (indexPath.row == SettingsContactRowContact) {
            [self openFeedbackMenuView];
        }
        else if (indexPath.row == SettingsContactRowTwitter) {
            [self openFacebookPage];
        }
        else if (indexPath.row == SettingsContactRowAbout) {
            [self.navigationController pushViewController:[SobreViewController new]
                                                 animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return CELL_DEFAULT_HEIGHT;
}

#pragma mark - BlurViewDelegate

- (void)blurViewDidTouchOnBackground {

    [self closeFeedbackMenu];
}

#pragma mark - FeedbackViewDelegate

- (void)feedbackMenuDidClickOnReportBug {

    [self openFeedBackFormWithType:FeedbackTypeProblem];
}

- (void)feedbackMenuDidClickOnSuggestion {

    [self openFeedBackFormWithType:FeedbackTypeSuggestion];
}

- (void)feedbackMenuDidClickOnOther {

    [self openFeedBackFormWithType:FeedbackTypeOther];
}

- (void)feedbackMenuDidClickOnCloseView {

    [self closeFeedbackMenu];
}

#pragma mark - Event Handler

- (void)notificationSwitcherOption:(UISwitch *)switcher {

    if (switcher.tag == SettingsNotificationRowFullNota) {
        [self saveShowNotaForUserWithSwitch:switcher];
    }

    else if (switcher.tag == SettingsNotificationRowPushOnce) {
        if (switcher.on == YES) {
            [[[UIAlertView alloc] initWithTitle:@"AVISO!"
                                        message:@"Recomendamos que você deixe essa opção desligada para não perder nenhuma notificação."
                                        "Você só vai parar de receber a mesma notificação da mesma nota somente após abrir o aplicativo novamente."
                                       delegate:nil
                              cancelButtonTitle:@"Ok, Entendi!"
                              otherButtonTitles:nil] show];
        }
        [self savePushOnlyOnceForUserWithSwitch:switcher];
    }
}

- (void)openFeedbackMenuView {

    self.viewBlur.alpha = 0.0f;
    self.viewFeedbackBg.alpha = 1.0f;

    [self.viewFeedBack animate];

    [self.tabBarController.view addSubviewAndFillWithContent:self.viewFeedbackBg];

    [UIView animateWithDuration:0.2f animations:^{
        self.viewBlur.alpha = 1.0f;
    }];
}

- (void)requestServersStatusForRow:(NSInteger)row {

    /**
     *  Request TIA Status
     */
    if (row == SettingsServerStatusRowTIA) {
        [ConnectionHelper requestForTiaStatusWithBlockSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

            DDLogVerbose(@"Status do TIA: %ld", (long)operation.response.statusCode);
            if (operation.response.statusCode == HTTPCode200OK) {
                DDLogVerbose(@"Tia Online!");
                self.isTiaOnline = YES;
            }
            else {
                DDLogVerbose(@"Tia Offline!");
                self.isTiaOnline = NO;
            }

            self.hasReloadedTia = YES;

            if ([PFUser currentUser]) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowTIA inSection:SettingsSectionServerStatus]]
                                      withRowAnimation:UITableViewRowAnimationNone];
            }

        } andBlockFailure:^(AFHTTPRequestOperation *operation, NSError *error) {

            DDLogVerbose(@"Tia Offline!");
            self.isTiaOnline = NO;
            self.hasReloadedTia = YES;

            if ([PFUser currentUser]) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowTIA inSection:SettingsSectionServerStatus]]
                                      withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    /**
     *  Request WS Status
     */
    else if (row == SettingsServerStatusRowWS) {
        [[ConnectionHelper sharedClient] requestForWSStatusWithBlockSuccess:^(NSURLSessionDataTask *task, id responseObject) {

            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

            DDLogVerbose(@"Status do WS: %ld", (long)response.statusCode);
            if (response.statusCode == HTTPCode200OK) {
                self.isWSOnline = YES;
            }
            else {
                DDLogVerbose(@"WS Offline!");
                self.isWSOnline = NO;
            }
            self.hasReloadedWS = YES;

            if ([PFUser currentUser]) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowWS inSection:SettingsSectionServerStatus]]
                                      withRowAnimation:UITableViewRowAnimationNone];
            }

        } andBlockFailure:^(NSURLSessionDataTask *task, NSError *error) {

            self.isWSOnline = NO;
            self.hasReloadedWS = YES;

            if ([PFUser currentUser]) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowWS
                                                                            inSection:SettingsSectionServerStatus]]
                                      withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
    /**
     *  Request WS Push Status
     */
    else if (self.hasPush && row == SettingsServerStatusRowWSPush) {
        [[ConnectionHelper sharedClient] requestForWSPushStatusWithBlockSuccess:^(NSURLSessionDataTask *task, id responseObject) {

            NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;

            DDLogVerbose(@"Status do WSPush: %ld", (long)response.statusCode);
            if (response.statusCode == HTTPCode200OK) {
                self.isWSPushOnline = YES;
            }
            else {
                DDLogVerbose(@"WSPush Offline!");
                self.isWSPushOnline = NO;
            }
            self.hasReloadedWSPush = YES;

            if ([PFUser currentUser]) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowWSPush
                                                                            inSection:SettingsSectionServerStatus]]
                                      withRowAnimation:UITableViewRowAnimationNone];
            }

        } andBlockFailure:^(NSURLSessionDataTask *task, NSError *error) {

            self.isWSPushOnline = NO;
            self.hasReloadedWSPush = YES;

            if ([PFUser currentUser]) {
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowWSPush
                                                                            inSection:SettingsSectionServerStatus]]
                                      withRowAnimation:UITableViewRowAnimationNone];
            }
        }];
    }
}

- (void)logoutCurrentUser {

    [LocalUser clearAllData];

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        [PFUser logOutInBackgroundWithBlock:^(NSError * error) {
            if (!error) {
                [[NSNotificationCenter defaultCenter] postNotificationName:kSettingsViewControllerWillLogoutUserNotification
                                                                    object:self];
            }
            else {
                [[UIAlertView alertViewAllFailedWithError:error] show];
            }
        }];
    }
}

#pragma mark - Private Methods

- (void)updateCurrentUserAndReload {

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        BOOL hasPush = [currentUser[@"hasPush"] boolValue];
        BOOL shouldShowNota = [currentUser[@"showNota"] boolValue];
        BOOL shouldPushOnlyOnce = [currentUser[@"pushOnlyOnce"] boolValue];

        [currentUser fetchInBackgroundWithBlock:^(PFObject *object,  NSError *error) {

            if (!error && currentUser) {

                [self.tableView beginUpdates];

                BOOL updatedHasPush = [object[@"hasPush"] boolValue];
                BOOL updatedShouldShowNota = [object[@"showNota"] boolValue];
                BOOL updatedShouldPushOnlyOnce = [object[@"pushOnlyOnce"] boolValue];
                BOOL shouldUpdateWSPushRow = NO;

                if (hasPush != updatedHasPush) {
                    if (updatedHasPush) {
                        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowWSPush
                                                                                    inSection:SettingsSectionServerStatus],
                                                                 [NSIndexPath indexPathForRow:SettingsNotificationRowPushOnce
                                                                                    inSection:SettingsSectionNotification],
                                                                 [NSIndexPath indexPathForRow:SettingsNotificationRowInvite
                                                                                    inSection:SettingsSectionNotification]]
                                              withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsNotificationRowFullNota
                                                                                    inSection:SettingsSectionNotification
                                                                  ]] withRowAnimation:UITableViewRowAnimationAutomatic];
                        shouldUpdateWSPushRow = YES;
                    }
                    else {
                        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsServerStatusRowWSPush
                                                                                    inSection:SettingsSectionServerStatus],
                                                                 [NSIndexPath indexPathForRow:SettingsNotificationRowPushOnce
                                                                                    inSection:SettingsSectionNotification],
                                                                 [NSIndexPath indexPathForRow:SettingsNotificationRowInvite
                                                                                    inSection:SettingsSectionNotification]]
                                              withRowAnimation:UITableViewRowAnimationAutomatic];
                        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:SettingsNotificationRowFullNota
                                                                                    inSection:SettingsSectionNotification
                                                                  ]] withRowAnimation:UITableViewRowAnimationAutomatic];
                    }
                }

                if ((shouldShowNota != updatedShouldShowNota ||
                     shouldPushOnlyOnce != updatedShouldPushOnlyOnce) && updatedHasPush) {
                    [self.tableView reloadSection:SettingsSectionNotification];
                }
                
                [self.tableView endUpdates];
                if (shouldUpdateWSPushRow) {
                    [self requestServersStatusForRow:SettingsServerStatusRowWSPush];
                }
            }
            else {
                [[UIAlertView alertViewAllFailedWithError:error] show];
            }
        }];
    }
}

- (void)closeFeedbackMenu {

    [self.viewFeedbackBg removeFromSuperViewAnimatedCompletion:^(BOOL finished) {

    }];
}

- (void)openFacebookPage {

    NSURL *facebookURL = [NSURL URLWithString:fstr(@"fb://profile/%@", FACEBOOK_PAGE_ID)];
    if ([[UIApplication sharedApplication] canOpenURL:facebookURL]) {
        [[UIApplication sharedApplication] openURL:facebookURL];
    }
    else {
        MNNavigationController *nav = [[MNNavigationController alloc]
                                       initWithRootViewController:[[WebViewController alloc]
                                                                   initWithURL:URL_TWITTER]];
        [self.navigationController presentViewController:nav animated:YES completion:nil];
    }
}

- (void)openFeedBackFormWithType:(FeedbackType)type {

    FeedbackFormViewController *feedbackView = [[FeedbackFormViewController alloc]
                                                initWithType:type];
    MNNavigationController *navCont = [[MNNavigationController alloc]
                                       initWithRootViewController:feedbackView];

    [self.navigationController presentViewController:navCont
                                            animated:YES
                                          completion:nil];
}

- (void)saveShowNotaForUserWithSwitch:(UISwitch *)switcher {

    PFUser *currentUser = [PFUser currentUser];
    [UIView animateWithDuration:0.3f animations:^{
        switcher.enabled = NO;
    }];

    if (currentUser) {
        currentUser[@"showNota"] = @(switcher.on);
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!succeeded) {
                DDLogError(@"Error: save show nota %@",error);
                NSNumber *optionStatus = currentUser[@"showNota"];
                [[UIAlertView alertViewAllFailedWithError:error] show];
                [switcher setOn:!optionStatus.boolValue animated:YES];
            }
            DDLogVerbose(@"ShowNota Salvo!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4f animations:^{
                    switcher.enabled = YES;
                }];
            });
        }];
    }
}

- (void)savePushOnlyOnceForUserWithSwitch:(UISwitch *)switcher {

    PFUser *currentUser = [PFUser currentUser];
    [UIView animateWithDuration:0.3f animations:^{
        switcher.enabled = NO;
    }];

    if (currentUser) {
        currentUser[@"pushOnlyOnce"] = @(switcher.on);
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (!succeeded) {
                DDLogError(@"Error: pushOnlyOnce nota %@",error);
                NSNumber *optionStatus = currentUser[@"pushOnlyOnce"];
                [[UIAlertView alertViewAllFailedWithError:error] show];
                [switcher setOn:!optionStatus.boolValue animated:YES];
            }
            DDLogVerbose(@"pushOnlyOnce Salvo!");
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.4f animations:^{
                    switcher.enabled = YES;
                }];
            });
        }];
    }
}

- (void)reloadTableView {

    if (self.isViewLoaded) {
        [self.tableView reloadData];
    }
}

@end
