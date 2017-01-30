//
//  ConvidarAmigoViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 12/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "ConvidarAmigoViewController.h"

/**
 *  Cell
 */
#import "FormCell.h"
#import "SendInviteCell.h"

/**
 *  Helpers
 */
#import "UITableView+Helper.h"

/**
 *  Model
 */
#import "Invite.h"

NSString static *kCellTitleNoOneInvited = @"Você ainda não convidou ninguém :(";
NSString static *kCellTitleDontHasInvite= @"Você não possui nenhum convite!";
NSString static *kCellTitleHasOneInvite = @"Você possui %ld convite!";
NSString static *kCellTitleHasManyInvite= @"Você possui %ld convites!";

NSInteger static kNumberOfInitialSection = 0;

@interface ConvidarAmigoViewController ()

typedef NS_ENUM(NSInteger, ConvidarAmigoSection) {
    ConvidarAmigoSectionInvited = 0,
    ConvidarAmigoSectionTIA,
    ConvidarAmigoSectionSendInvite,
    ConvidarAmigoSectionCount
};

@property (nonatomic) NSDictionary *dicRowTitles;
@property (nonatomic) NSArray *arraySectionTitles;
@property (nonatomic) NSString *stringTIA;

@property (nonatomic) Invite *invite;

@property (nonatomic) BOOL shouldEnableInviteCell;

@end

@implementation ConvidarAmigoViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStyleGrouped];

    if (self) {
        self.title = @"Convide para receber notificação";
        self.dicRowTitles = @{@(ConvidarAmigoSectionTIA) : @[@"TIA do usuário"],
                              @(ConvidarAmigoSectionSendInvite) : @[]};
        self.arraySectionTitles = @[@"USUÁRIOS CONVIDADOS POR VOCÊ",
                                    @"CONVIDAR UM USUÁRIO",
                                    @""];

    }

    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cellOrdinary"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([FormCell class])
                                               bundle:nil]
         forCellReuseIdentifier:@"cellTextInput"];

    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([SendInviteCell class])
                                               bundle:nil]
         forCellReuseIdentifier:@"cellSendInvite"];

    [self requestUserInvites];
    [self setupRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {

    DDLogVerbose(@"View deallocated: %@", NSStringFromClass(self.class));
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [GAHelper trackViewWithName:NSStringFromClass(self.class)];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [self numberOfSectionsForTableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == ConvidarAmigoSectionInvited) {
        if (!self.invite.hasInvitedAnyone) {
            return 2;
        }
        return self.invite.numberOfInvitedUsers + 1;
    }

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == ConvidarAmigoSectionInvited) {
        UITableViewCell *cell = [tableView
                                 dequeueReusableCellWithIdentifier:@"cellOrdinary"
                                 forIndexPath:indexPath];

        cell.textLabel.text = [self invitedCellTitleWithIndexPath:indexPath];
        return cell;
    }

    if (indexPath.section == ConvidarAmigoSectionTIA) {

        FormCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellTextInput"
                                               forIndexPath:indexPath];
        [cell setTextFieldDelegate:self
                            andTag:indexPath.section
                   andKeyboardType:UIKeyboardTypeNumberPad];

        [cell loadWithPlaceholderTitle:self.dicRowTitles[@(ConvidarAmigoSectionTIA)][indexPath.row]];
        return cell;
    }

    else if (indexPath.section == ConvidarAmigoSectionSendInvite) {

        SendInviteCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellSendInvite"
                                                         forIndexPath:indexPath];
        [cell enableCell:self.shouldEnableInviteCell];
        return cell;
    }

    return nil;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.arraySectionTitles[section];
}

#pragma mark - UITableViewController Delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];

    [self.view endEditing:YES];

    if (indexPath.section == ConvidarAmigoSectionSendInvite) {
        [self saveInvite];
    }
}

#pragma mark - UITextFieldDelegate (FormCell)

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range
replacementString:(NSString *)string {

    NSUInteger oldLength = textField.text.length;
    NSUInteger replacementLength = string.length;
    NSUInteger rangeLength = range.length;
    NSUInteger max_length = 8;
    NSUInteger newLength = oldLength - rangeLength + replacementLength;

    if (textField.tag == ConvidarAmigoSectionTIA) {
        if (range.location < max_length  && [string isEqualToString:@""]) {
            [self enableInviteCell:NO];
        }
        else if (newLength == max_length && textField.text.length >= 1) {
            [self enableInviteCell:YES];
        }
    }

    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;

    return newLength <= max_length || returnKey;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self.view endEditing:YES];

    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {

    if (textField.tag == ConvidarAmigoSectionTIA) {
        self.stringTIA = textField.text;
    }

    return YES;
}

#pragma mark - Private Methods

- (void)requestUserInvites {

    [PFCloud requestUserInvitesWithBlock:^(PFObject *object,  NSError *error) {

        if (!error && object.class == [Invite class]) {
            self.invite = (Invite *)object;
            [self.tableView reloadData];
        }
        else if (error) {
            [[UIAlertView alertViewAllFailedWithError:error] show];
        }
        [self.refreshControl endRefreshing];
    }];
}

- (void)setupRefreshControl {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(requestUserInvites)
                  forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
}

- (NSInteger)numberOfSectionsForTableView {

    if (self.invite) {
        return !self.invite.hasInvites ? 1 : ConvidarAmigoSectionCount;
    }

    return kNumberOfInitialSection;
}

- (NSString *)invitedCellTitleWithIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row < self.invite.numberOfInvitedUsers) {
        return [self.invite invitedUserForIndexPath:indexPath];
    }
    else {
        if (!self.invite.hasInvitedAnyone &&
            indexPath.row == 0) {
            return kCellTitleNoOneInvited;
        }
        if (!self.invite.hasInvites) {
            return kCellTitleDontHasInvite;
        }
        else if (self.invite.numberOfInvitesAvailable == 1) {
            return fstr(kCellTitleHasOneInvite, self.invite.numberOfInvitesAvailable);
        }
        else if (self.invite.numberOfInvitesAvailable > 1) {
            return fstr(kCellTitleHasManyInvite, self.invite.numberOfInvitesAvailable);
        }
    }
    return @"";
}

- (void)enableInviteCell:(BOOL)shouldEnable {

    SendInviteCell *cell = (SendInviteCell *)[self.tableView
                                              cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0
                                                                                       inSection:ConvidarAmigoSectionSendInvite]];
    self.shouldEnableInviteCell = shouldEnable;
    [cell enableCell:shouldEnable];
}

#pragma mark - Parse Methods

- (void)saveInvite {

    [self.tableView endEditing:YES];

    [PFCloud inviteUserToPushWithTia:self.stringTIA andBlock:^(id object, NSError *error) {

        if (!error) {
            self.invite = (Invite *)object;
            if (self.invite.hasInvites) {
                [self.tableView reloadSections:@[@(ConvidarAmigoSectionInvited),
                                                 @(ConvidarAmigoSectionTIA)]];
            }
            else {
                [self.tableView reloadData];
            }
        }
        else {
            [[UIAlertView alertViewWithParseError:error] show];
            [self.invite fetchInBackgroundWithBlock:^(PFObject *object,  NSError *error) {

                if (!error) {
                    self.invite = (Invite *)object;
                    [self.tableView reloadData];
                }
                else {
                    [[UIAlertView alertViewWithParseError:error] show];
                }
            }];
        }
    }];
}

@end
