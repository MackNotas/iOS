//
//  FeedbackFormViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 21/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "FeedbackFormViewController.h"

/**
 Cells
 */
#import "FormCell.h"
#import "MessageCell.h"
#import "SendInviteCell.h"

/**
 *  Model
 */
#import "Feedback.h"
#import "LocalUser.h"

/**
 *  Controllers
 */
#import "LoadingViewController.h"

/**
 *  Helper
 */
#import "UIView+MackNotas.h"

@interface FeedbackFormViewController ()

typedef NS_ENUM(NSInteger, FeedbackFormSection) {
    FeedbackFormSectionNome = 0,
    FeedbackFormSectionEmail,
    FeedbackFormSectionMensagem,
    FeedbackFormSectionSendFeedback,
    FeedbackFormSectionCount
};

@property (nonatomic) FeedbackType type;
@property (nonatomic) NSArray *arrayTitles;
@property (nonatomic) NSArray *arrayPlaceholders;

@property (nonatomic) CGFloat keyboardHeight;
@property (nonatomic) NSInteger keyboardCurve;
@property (nonatomic) CGFloat keyboardDuration;

/**
 Field data
 */
@property (nonatomic) NSString *stringNomeCompleto;
@property (nonatomic) NSString *stringEmail;
@property (nonatomic) NSString *stringMensagem;

@end

@implementation FeedbackFormViewController

- (instancetype)initWithType:(FeedbackType)type {

    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _type = type;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FormCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([FormCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([MessageCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([MessageCell class])];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SendInviteCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([SendInviteCell class])];

    UIBarButtonItem *btnClose = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                                                                              target:self
                                                                              action:@selector(dismissViewController)];
    self.navigationItem.leftBarButtonItem = btnClose;

    self.arrayTitles = @[@"Relatar problema",
                     @"Sugestões",
                     @"Dúvidas e outros assuntos"];

    self.arrayPlaceholders = @[@"Descreva aqui o seu problema, se possível, descreva as etapas para reproduzi-lo!",
                               @"Escreva aqui suas sugestões para melhorar o MackNotas!",
                               @"Escreva aqui suas dúvidas ou fale sobre qualquer outro assunto!"];

    self.title = self.arrayTitles[self.type];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [GAHelper trackViewWithName:NSStringFromClass(self.class)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return FeedbackFormSectionCount;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == FeedbackFormSectionNome) {
        FormCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FormCell class])
                                                         forIndexPath:indexPath];
        [cell loadWithPlaceholderTitle:@"Nome"];
        cell.txtFieldInput.delegate = self;
        cell.txtFieldInput.tag = indexPath.section;
        return cell;
    }
    else if (indexPath.section == FeedbackFormSectionEmail) {
        FormCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([FormCell class])
                                                         forIndexPath:indexPath];
        [cell loadWithPlaceholderTitle:@"E-mail"
                          keyboardType:UIKeyboardTypeEmailAddress];
        cell.txtFieldInput.delegate = self;
        cell.txtFieldInput.tag = indexPath.section;

        return cell;
    }
    else if (indexPath.section == FeedbackFormSectionMensagem) {
        MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([MessageCell class])
                                                            forIndexPath:indexPath];
        [cell loadWithPlaceholder:self.arrayPlaceholders[self.type]];
        [cell setTextViewDelegate:self];
        return cell;
    }
    else if (indexPath.section == FeedbackFormSectionSendFeedback) {
        SendInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([SendInviteCell class])
                                                            forIndexPath:indexPath];
        [cell loadWithTitle:@"Enviar Mensagem!"];
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([cell isKindOfClass:[SendInviteCell class]]) {
        [(SendInviteCell *)cell enableCell:YES];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == FeedbackFormSectionMensagem) {
        return [MessageCell height];
    }

    return CELL_DEFAULT_HEIGHT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == FeedbackFormSectionSendFeedback) {

        if ([self isAllFormsFilled]) {
            LoadingViewController *loadView = [[LoadingViewController alloc] initWithCustomTitle:@"Enviando..."];

            if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
                [self.tableView addSubviewAndFillAnimated:loadView.view];
            }
            else {
                [self.tableView addSubview:loadView.view];
            }

            NSString *appVersion = fstr(@"%@ (%@)", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]);

            Feedback *feedback = [Feedback object];
            [feedback loadWithNomeCompleto:self.stringNomeCompleto
                                  mensagem:self.stringMensagem
                                     email:self.stringEmail
                                plataforma:@"iOS"
                                appVersion:appVersion
                                 osVersion:[GeneralHelper getOSVersion]
                             modeloCelular:[GeneralHelper getDeviceModel]
                                       TIA:[[LocalUser sharedInstance] tia]
                                   andTipo:self.type];
            [feedback saveInBackgroundWithBlock:^(BOOL succeeded, NSError * error) {
                if (succeeded) {
                    [loadView removeFromSuperViewCompletion:^(BOOL finished) {
                        if (finished) {
                            [self.navigationController
                             dismissViewControllerAnimated:YES
                             completion:^{
                                 [[UIAlertView alertViewWithCustomTitle:@"Mensagem enviada!"
                                                             andMessage:@"Sua mensagem foi enviada, caso necessário"
                                                                        " entraremos em contato. Obrigado =)"] show];
                             }];
                        }
                    }];
                }
                else if (error) {
                    [UIAlertView alertViewAllFailedWithError:error];
                }
            }];
        }
    }
}

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {

    if ([textView.text isEqualToString:self.arrayPlaceholders[self.type]]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidChange:(UITextView *)textView {

    self.stringMensagem = textView.text;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView {

    self.stringMensagem = textView.text;

    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {

    self.stringMensagem = textView.text;

    return YES;
}

#pragma mark - UITextFieldDelegate (FormCell)

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.view endEditing:YES];

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if (textField.tag == FeedbackFormSectionNome) {
        self.stringNomeCompleto = textField.text;
    }
    else if (textField.tag == FeedbackFormSectionEmail) {
        self.stringEmail = textField.text;
    }

    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {

    if (textField.tag == FeedbackFormSectionNome) {
        self.stringNomeCompleto = textField.text;
    }
    else if (textField.tag == FeedbackFormSectionEmail) {
        self.stringEmail = textField.text;
    }

    return YES;
}

#pragma mark - Private Methods

- (void)dismissViewController {

    [self.navigationController dismissViewControllerAnimated:YES
                                                  completion:nil];

}

- (BOOL)isAllFormsFilled {

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SendInviteCell *cell = (SendInviteCell *)[self.tableView
                                                  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                           inSection:FeedbackFormSectionSendFeedback]];
        [cell enableCell:YES];
    });

    if (![GeneralHelper isEmailValid:self.stringEmail.lowercaseString]) {
        [[UIAlertView alertViewWithCustomMessage:@"Verifique o endereço de e-mail digitado!"] show];
        return NO;
    }

    if ((self.stringEmail.length == 0) ||
         (self.stringMensagem.length == 0) ||
         (self.stringNomeCompleto.length == 0)) {
        [[UIAlertView alertViewWithCustomMessage:@"Preencha todos os campos!"] show];
        return NO;
    }



    return YES;
}

@end
