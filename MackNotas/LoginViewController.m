//
//  LoginViewController.m
//  Mack Notas
//
//  Created by Caio Remedio on 12/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "LoginViewController.h"
/**
 *  Frameworks
 */
#import <Parse/Parse.h>
#import <Crashlytics/Crashlytics.h>
#import <pop/POP.h>

/**
 *  Controllers
 */
#import "NotasViewController.h"
#import "LoadingViewController.h"
#import "SettingsViewController.h"

/**
 *  Helpers
 */
#import "UIView+MackNotas.h"

static const CGFloat fontSizeLogoLbl = 190.0f;

static CGFloat const kAnimationsDuration = 0.5f;
static CGFloat const kAnimationSpringDamping = 0.8f;
static CGFloat const kAnimationInitialVelocity = 0.2f;

static NSString * const LoginUnidadeSP = @"001";
static NSString * const LoginUnidadeTambore = @"002";
static NSString * const LoginUnidadeCampinas = @"001c";
static NSString * const LoginUnidadeBrasilia = @"003";

@interface LoginViewController ()

/**
 *  Views
 */
@property (strong, nonatomic) IBOutlet UITextField *txtFieldTia;
@property (strong, nonatomic) IBOutlet UITextField *txtFieldSenha;

@property (strong, nonatomic) IBOutlet UIButton *btnLogin;
@property (strong, nonatomic) IBOutlet UILabel *lblLogoMack;

@property (nonatomic) LoadingViewController *loadingView;
@property (strong, nonatomic) IBOutlet UIView *viewTxtContainer;
@property (nonatomic) UIActivityIndicatorView *actView;

/**
 *  Labels
 */
@property (strong, nonatomic) IBOutlet UILabel *lblIncorrect;

/**
 *  Objects
 */
@property (nonatomic) NSArray *originalSizes;

/**
 Constraint
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstnLogoHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstnLogoPosition;

/**
 Primitives
 */
@property (nonatomic) CGRect originalViewSize;

//=============================================================================//

/**
 Unidade Menu
 */
@property (strong, nonatomic) IBOutlet UIButton *btnMenuControl;

@property (strong, nonatomic) IBOutlet UIButton *btnSaoPaulo;
@property (strong, nonatomic) IBOutlet UIButton *btnTambore;
@property (strong, nonatomic) IBOutlet UIButton *btnCampinas;
@property (strong, nonatomic) IBOutlet UIButton *btnBrasilia;

@property (strong, nonatomic) IBOutlet UIView *viewMenuBackground;

/**
 Unidade Constraints
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrSaoPauloY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrTamboreY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrCampinasY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrBrasiliaY;

/**
 Unidade Primitives
 */
@property (nonatomic) NSString *unidadeValue;

@end

@implementation LoginViewController

- (instancetype)init {

    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];

    if (self) {
        self.view.backgroundColor = [UIColor vermelhoMainBackground];
        [self.btnLogin setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        self.txtFieldTia.tintColor = [UIColor whiteColor];
        self.txtFieldSenha.tintColor = [UIColor whiteColor];
        self.txtFieldTia.enablesReturnKeyAutomatically = YES;
        self.loadingView = [[LoadingViewController alloc] initWithLoadingType:LoadingTypeLogin];

        /**
         *  Unidade Menu
         */
        UIColor *colorUnidadeBtn = [UIColor colorWithWhite:1.0f alpha:0.8f];
        [self.btnMenuControl    setTitleColor:colorUnidadeBtn forState:UIControlStateNormal];
        [self.btnSaoPaulo       setTitleColor:colorUnidadeBtn forState:UIControlStateNormal];
        [self.btnTambore        setTitleColor:colorUnidadeBtn forState:UIControlStateNormal];
        [self.btnCampinas       setTitleColor:colorUnidadeBtn forState:UIControlStateNormal];
        [self.btnBrasilia       setTitleColor:colorUnidadeBtn forState:UIControlStateNormal];
        self.viewMenuBackground.backgroundColor = [UIColor vermelhoMainBackground];
        _unidadeValue = LoginUnidadeSP;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboardAndAdjustView)];

    [self.view addGestureRecognizer:tap];

    [self setupBtnLogin];

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        [PFCloud verifyPFUserAuthWithWebServiceWithBlock:^(NSDictionary *result, NSError *error) {
            DDLogError(@"verifyPFUserAuthWithWebService - TIA Response: %@", result);
            if (!error) {
                if (result[@"login"]) {
                    if ([result[@"login"] isEqual: @1]) {
                        [self didLoginSuccessful];
                    }
                    else {
                        [[UIAlertView alertViewLoginFailed] show];
                    }
                }
            }
            else {
                if (error.code == kPFErrorInvalidSessionToken) {
                    [[UIAlertView alertViewSessionError] show];
                    [LocalUser logout];
                }
                else {
                    [[UIAlertView alertViewTiaErrorWithError:error] show];
                }
            }
        }];
    }
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [GAHelper trackViewWithName:NSStringFromClass(self.class)];
    if (SCREEN_IS_3_5_INCHES) {
        self.lblLogoMack.font = [UIFont bitterBoldWithSize:fontSizeLogoLbl];
        self.cstnLogoHeight.constant = 135;
        self.cstnLogoPosition.constant = -140;
    }
    [self.btnLogin setTitleColor:[UIColor cinzaBtnLoginDisable] forState:UIControlStateDisabled];
    self.btnLogin.alpha = 0.6f;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (SCREEN_IS_3_5_INCHES) {
        self.originalViewSize = self.view.frame;
        self.originalSizes = @[@(fontSizeLogoLbl),
                               @(self.cstnLogoHeight.constant),
                               @(self.cstnLogoPosition.constant)];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    DDLogDebug(@"View dealocada: %@", NSStringFromClass(self.class));
}

- (void)setupBtnLogin {

    [self.btnLogin addSubview:self.actView];

    self.actView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.btnLogin addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[_actView]-16-|"
                                                                          options:0
                                                                          metrics:nil
                                                                            views:@{@"_actView" : self.actView}]];
    [self.btnLogin addConstraint:[NSLayoutConstraint constraintWithItem:self.actView
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.btnLogin
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0f
                                                               constant:0.0f]];
}

#pragma mark Event Handler

- (void)didLoginSuccessful {

    if (self.presentingViewController.presentedViewController == self) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        [[NSNotificationCenter defaultCenter] postNotificationName:kSettingsViewControllerDidLoginUserNotification
                                                            object:nil
                                                          userInfo:nil];
    }
}

- (void)enableBtnLogin:(BOOL)enabled {

    if (enabled) {
        self.btnLogin.enabled = YES;
        [UIView animateWithDuration:0.3f animations:^{
            [self.btnLogin setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            self.btnLogin.alpha = 1.0f;
        }];
    }
    else {
        self.btnLogin.enabled = NO;
        [self shouldShowIncorrectLogin:NO];
        [UIView animateWithDuration:0.3f animations:^{
            [self.btnLogin setTitleColor:[UIColor cinzaBtnLoginDisable] forState:UIControlStateDisabled];
            self.btnLogin.alpha = 0.6f;
        }];
    }
}

- (void)dismissKeyboardAndAdjustView {

    if (SCREEN_IS_3_5_INCHES &&
        (self.txtFieldTia.isEditing || self.txtFieldSenha.isEditing)) {

        self.view.bounds = CGRectInset(self.originalViewSize, 0.0f, 0.0f);
        self.cstnLogoHeight.constant = [self.originalSizes[1] floatValue];
        self.cstnLogoPosition.constant = [self.originalSizes[2] floatValue];
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
            [self.lblLogoMack layoutIfNeeded];
        }
         completion:^(BOOL finished) {
             self.lblLogoMack.font = [UIFont bitterBoldWithSize:[self.originalSizes[0]floatValue]];
         }];
    }
    if (!(SCREEN_IS_3_5_INCHES)) {

    }
    [self hideUnidadeMenu];
    [self.view endEditing:YES];
}

- (IBAction)btnLoginClick:(id)sender {

    __block NSString *userTia = self.txtFieldTia.text;
    __block NSString *userSenha = self.txtFieldSenha.text;

    __weak __typeof(self)weakSelf = self;

    LocalUser *localUser = [LocalUser new];
    [self dismissKeyboardAndAdjustView];
    [self enableBtnLogin:NO];
    [self startActivityIndicator];

    [PFCloud verifyTiaBeforeSignUpWithTIA:userTia andPassword:userSenha andUnidade:self.unidadeValue andWithBlock:^(NSDictionary *result, NSError *error) {
        DDLogDebug(@"VerifyTiaBeforeSignUp Response: %@", result);
        if (!error) {
            if (result[@"login"]) {
                if ([result[@"login"] isEqual: @1]) {
                    [localUser loadUserTia:userTia
                                     senha:userSenha
                                   unidade:weakSelf.unidadeValue
                            serverResponse:result];
                    [NSKeyedArchiver archiveRootObject:localUser toFile:[GeneralHelper pathForUserDataFile]];
                    [weakSelf continueToVerifyLoginInfosOnCloudWithTia:userTia andPass:userSenha];
                }
                else if ([result[@"login"] isEqual: @0]) {
                    [self handleLoginError:nil isLoginIncorrect:YES];
                }
            }
        }
        else {
            [self handleLoginError:error isLoginIncorrect:NO];
        }
    }];
}

- (void)updatePFUserInformations {

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    PFUser *user = [PFUser currentUser];

    LocalUser *localUser = [LocalUser sharedInstance];

    if (user) {
        localUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[GeneralHelper
                                                                pathForUserDataFile]];
        currentInstallation[@"user"] = user;
        currentInstallation.channels = @[fstr(@"t%@",user.username)];

        [[Crashlytics sharedInstance] setUserName:localUser.nomeCompleto];
        [[Crashlytics sharedInstance] setUserIdentifier:user.username];

        user[@"curso"] = localUser.curso;
        user[@"nome"] = localUser.nomeCompleto;
        user[@"unidade"] = localUser.unidade;
        user[@"email"] = fstr(@"%@@mackenzista.com.br",localUser.tia);
        [user saveInBackground];
    }
    if (currentInstallation) {
        [currentInstallation saveInBackground];
    }
}

- (void)continueToVerifyLoginInfosOnCloudWithTia:(NSString *)userTia
                                         andPass:(NSString *)userSenha {

    __weak __typeof(self)weakSelf = self;

    [PFUser logInWithUsernameInBackground:userTia password:userSenha block:^(PFUser *user, NSError *error) {
        if (user) {
            NSLog(@"Logado com sucesso!");
            [weakSelf updatePFUserInformations];
            [weakSelf didLoginSuccessful];
        }
        else {
            if ([error code] == kPFErrorObjectNotFound) {
                [PFCloud signUpInBackgroundWithTIA:userTia andPassword:userSenha andUnidade:self.unidadeValue andWithBlock:^(BOOL succeeded, NSError *error) {
                    if (!error) {
                        NSLog(@"Ok Registrado!");
                        [weakSelf settingsForUserOnSingUp];
                        [weakSelf updatePFUserInformations];
                        [PFCloud encryptPassWithPFUserAtSignUpWithPass:userSenha];
                        [weakSelf didLoginSuccessful];
                    }
                    else if ([error code] == kPFErrorAccountAlreadyLinked || [error code] == kPFErrorUsernameTaken) {
                        [PFCloud updateRegisteredUserPasswordWithTia:userTia andPassword:userSenha andUnidade:self.unidadeValue andWithBlock:^(NSString *result, NSError *error) {
                            if ([result isEqualToString:@"true"]) {
                                [PFUser logInWithUsernameInBackground:userTia password:userSenha block:^(PFUser * user, NSError * error) {
                                    if (user) {
                                        [weakSelf updatePFUserInformations];
                                        [weakSelf didLoginSuccessful];
                                    }
                                    if ([error code] == kPFErrorObjectNotFound) {
                                        [self handleLoginError:error isLoginIncorrect:NO];
                                    }
                                }];
                            }
                            else {
                                [self handleLoginError:error isLoginIncorrect:NO];
                            }
                        }];
                    }
                    else {
                        [self handleLoginError:error isLoginIncorrect:NO];
                    }
                }];
            }
            else {
                [self handleLoginError:error isLoginIncorrect:NO];
            }
        }
    }];

}

- (void)settingsForUserOnSingUp {

    PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        currentUser[@"showNota"] = @(YES);
        currentUser[@"pushOnlyOnce"] = @(YES);
        [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
            if (!succeeded) {
                [self handleLoginError:error isLoginIncorrect:NO];
            }
        }];
    }
}

#pragma mark - Unidade Menu Events Handler

- (IBAction)btnMenuControlClick:(id)sender {

    [self showUnidadeMenuCompletion:^(BOOL finished) {
        if (finished) {
            self.viewMenuBackground.hidden = YES;
            self.btnMenuControl.hidden = YES;
        }
    }];
}

- (IBAction)btnSaoPauloClick:(id)sender {

    self.unidadeValue = LoginUnidadeSP;
    [self hideUnidadeMenu];

}
- (IBAction)btnTamboreClick:(id)sender {

    self.unidadeValue = LoginUnidadeTambore;
    [self hideUnidadeMenu];
}
- (IBAction)btnCampinasClick:(id)sender {

    self.unidadeValue = LoginUnidadeCampinas;
    [self hideUnidadeMenu];
}
- (IBAction)btnBrasiliaClick:(id)sender {

    self.unidadeValue = LoginUnidadeBrasilia;
    [self hideUnidadeMenu];
}

- (void)showUnidadeMenuCompletion:(void (^)(BOOL finished))completion {

    [self animateBlock:^{
        self.cstrBrasiliaY.constant = -205;
        [self.view layoutIfNeeded];
    } delay:0.0f completion:nil];
    [self animateBlock:^{
        self.cstrCampinasY.constant = -172;
        [self.view layoutIfNeeded];
    } delay:0.1f completion:nil];
    [self animateBlock:^{
        self.cstrTamboreY.constant = -139;
        [self.view layoutIfNeeded];
    } delay:0.2f completion:completion];
}

- (void)hideUnidadeMenu {

    self.viewMenuBackground.hidden = NO;
    self.btnMenuControl.hidden = NO;

    [self animateBlock:^{
        self.cstrTamboreY.constant = -106;
        [self.view layoutIfNeeded];
    } delay:0.0f completion:nil];
    [self animateBlock:^{
        self.cstrCampinasY.constant = -106;
        [self.view layoutIfNeeded];
    } delay:0.1f completion:nil];
    [self animateBlock:^{
        self.cstrBrasiliaY.constant = -106;
        [self.view layoutIfNeeded];
    } delay:0.2f completion:nil];
}

- (void)animateBlock:(void(^)(void))block delay:(NSTimeInterval)delay completion:(void (^)(BOOL finished))completion {

    [UIView
     animateWithDuration:kAnimationsDuration
     delay:delay
     usingSpringWithDamping:kAnimationSpringDamping
     initialSpringVelocity:kAnimationInitialVelocity
     options:UIViewAnimationOptionAllowUserInteraction
     animations:block
     completion:completion];
}

- (void)setUnidadeValue:(NSString *)unidadeValue {

    if (unidadeValue == LoginUnidadeSP) {
        [self.btnMenuControl setTitle:@"São Paulo" forState:UIControlStateNormal];
    }
    else if (unidadeValue == LoginUnidadeTambore) {
        [self.btnMenuControl setTitle:@"Tamboré" forState:UIControlStateNormal];
    }
    else if (unidadeValue == LoginUnidadeCampinas) {
        [self.btnMenuControl setTitle:@"Campinas" forState:UIControlStateNormal];
    }
    else if (unidadeValue == LoginUnidadeBrasilia) {
        [self.btnMenuControl setTitle:@"Brasília" forState:UIControlStateNormal];
    }

    _unidadeValue = unidadeValue == LoginUnidadeCampinas ? LoginUnidadeSP : unidadeValue;
}

#pragma mark - Private Methods

- (void)animateIncorrectPassword {

    POPSpringAnimation *shake = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];

    shake.springBounciness = 20;
    shake.velocity = @(3000);
    [self.viewTxtContainer pop_addAnimation:shake forKey:@"shakePassword"];
    [self.viewTxtContainer.layer setNeedsDisplay];
    [self.viewTxtContainer.layer setNeedsLayout];

    [self stopActivityIndicator];
}

- (void)stopActivityIndicator {

    [UIView animateWithDuration:0.3f animations:^{
        self.actView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self.actView stopAnimating];
        }
    }];
}

- (void)startActivityIndicator {

    [self.actView startAnimating];
    [UIView animateWithDuration:0.3f animations:^{
        self.actView.alpha = 1.0f;
    }];
}

- (void)shouldShowIncorrectLogin:(BOOL)show {

    CGFloat const alpha = show ? 1.0f : 0.0f;

    [UIView animateWithDuration:0.3f animations:^{
        self.lblIncorrect.alpha = alpha;
    }];
}

- (void)handleLoginError:(NSError *)error isLoginIncorrect:(BOOL)isLoginIncorrect{

    [self stopActivityIndicator];
    [self enableBtnLogin:YES];
    [self shouldShowIncorrectLogin:isLoginIncorrect];

    if (isLoginIncorrect) {
        [self animateIncorrectPassword];
    }
    if (error) {
        DDLogError(@"%s %@", __func__, error);
        if ([error code] == kPFErrorConnectionFailed ||
            [error code] == kPFErrorInternalServer ||
            [error code] == kPFScriptError) {
            [[UIAlertView alertViewTiaErrorWithError:error] show];
        }
        else {
            [[UIAlertView alertViewAllFailedWithError:error] show];
        }
    }
}

#pragma mark - Properties

- (UIActivityIndicatorView *)actView {

    if (_actView) {
        return _actView;
    }

    _actView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _actView.hidesWhenStopped = NO;
    _actView.alpha = 0.0f;
    [_actView stopAnimating];

    return _actView;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textField:(UITextField *)textField
shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {

    NSUInteger oldLength = textField.text.length;
    NSUInteger replacementLength = string.length;
    NSUInteger rangeLength = range.length;
    NSUInteger max_length = textField == self.txtFieldTia ? 8 : 15;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;

    if (self.txtFieldTia == textField) {
        if (range.location < max_length  && [string isEqualToString:@""]) {
            [self enableBtnLogin:NO];
        }
        else if (newLength == max_length && self.txtFieldSenha.text.length >= 1) {
            [self enableBtnLogin:YES];
        }
    }

    else if (self.txtFieldSenha == textField) {
        if (newLength == 0 && [string isEqualToString:@""]) {
            [self enableBtnLogin:NO];
        }
        else if (newLength >= 1 && self.txtFieldTia.text.length == 8) {
            [self enableBtnLogin:YES];
        }
    }

    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;

    return newLength <= max_length || returnKey;
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {

    [self enableBtnLogin:NO];

    return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {

    if (SCREEN_IS_3_5_INCHES && (!self.txtFieldSenha.isEditing && !self.txtFieldTia.isEditing)) {
        [self hideUnidadeMenu];
        self.view.bounds = CGRectInset(self.view.frame, 0.0f, 44.0f);
        self.cstnLogoHeight.constant = 110;
        self.cstnLogoPosition.constant = -105;

        [UIView animateWithDuration:0.4 animations:^{
            [self.view layoutIfNeeded];
            self.lblLogoMack.font = [UIFont bitterBoldWithSize:120.0f];
            [self.lblLogoMack layoutIfNeeded];
        }];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self btnLoginClick:nil];

    return YES;
}

@end
