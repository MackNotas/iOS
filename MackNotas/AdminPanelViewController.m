//
//  AdminPanelViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 06/12/15.
//  Copyright © 2015 Caio Remedio. All rights reserved.
//

#import "AdminPanelViewController.h"
#import "AdminPanelLogCell.h"

NSString static * const kOrdinaryCell = @"ordinaryCell";

typedef NS_ENUM(NSInteger, AdminUserRow) {
    AdminUserRowTIAByName = 0,
    AdminUserRowNameByTia,
    AdminUserRowInvites,
    AdminUserRowCount
};

@interface AdminPanelViewController () <UIAlertViewDelegate>

@property (nonatomic) NSArray *cellTitles;
@property (nonatomic) NSArray *sectionTitles;

@property (nonatomic) NSMutableAttributedString *logString;

@end

@implementation AdminPanelViewController

#pragma mark - View Life Cycle

- (instancetype)init {

    self = [super initWithNibName:NSStringFromClass([AdminPanelViewController class])
                           bundle:nil];
    if (self) {
        _cellTitles = @[@"Buscar TIA por nome",
                            @"Buscar nome por TIA",
                            @"Dar convites a usuário"];
        _sectionTitles = @[@"USUÁRIOS", @"LOGS"];
        _logString = [NSMutableAttributedString new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:kOrdinaryCell];
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([AdminPanelLogCell class])
                                               bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([AdminPanelLogCell class])];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return AdminUserRowCount;
    }
    if (section == 1) {
        return 2;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {

        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrdinaryCell
                                                                forIndexPath:indexPath];

        cell.textLabel.text = self.cellTitles[indexPath.row];
        
        return cell;
        
    }

    if (indexPath.section == 1) {

        if (indexPath.row == 0) {
            AdminPanelLogCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([AdminPanelLogCell class])
                                                                      forIndexPath:indexPath];

            [cell loadWithLog:self.logString];
            return cell;
        }
        if (indexPath.row == 1) {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kOrdinaryCell
                                                                    forIndexPath:indexPath];

            cell.textLabel.text = @"Limpar Logs";
            return cell;
        }
    }

    return nil;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (indexPath.section == 0) {
        if (indexPath.row == AdminUserRowTIAByName) {
            UIAlertView *alertView = [UIAlertView alertViewWithTextInputTitle:@"Query TIA por NOME" message:nil];
            alertView.delegate = self;
            alertView.tag = AdminUserRowTIAByName;
            [alertView show];
        }
        else if (indexPath.row == AdminUserRowNameByTia) {
            UIAlertView *alertView = [UIAlertView alertViewWithTextInputTitle:@"Query NOME por TIA" message:nil];
            alertView.delegate = self;
            alertView.tag = AdminUserRowNameByTia;
            [alertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeDecimalPad;
            [alertView show];
        }
        else if (indexPath.row == AdminUserRowInvites) {
//            UIAlertView *alertView = [UIAlertView alertViewWithTextInputTitle:@"Dar 10 invites ao user" message:nil];
//            alertView.delegate = self;
//            alertView.tag = AdminUserRowInvites;
//            [alertView show];
        }
    }
    else if (indexPath.section == 1) {
        if (indexPath.row == 1) {
            self.logString = [NSMutableAttributedString new];
            [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                          withRowAnimation:UITableViewRowAnimationAutomatic];
        }
    }

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.sectionTitles[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return 44.0f;
    }
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            return [AdminPanelLogCell height];
        }
        if (indexPath.row == 1) {
            return 44.0;
        }
    }

    return 0.0f;
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (buttonIndex != 1) {
        return;
    }

    UITextField *txtFieldFromAlert = [alertView textFieldAtIndex:0];
    NSString *searchInput = txtFieldFromAlert.text;

    if (searchInput.length <= 0) {
        return;
    }

    [self performQueryWithSearchString:searchInput
                                  type:alertView.tag];
}

- (void)performQueryWithSearchString:(NSString *)searchString type:(AdminUserRow)type {

    PFQuery *query;

    if (type == AdminUserRowTIAByName) {
        query = [PFUser query];
        [query whereKey:@"nome" containsString:searchString.uppercaseString];
    }
    else if (type == AdminUserRowNameByTia) {
        query = [PFUser query];
        [query whereKey:@"username" containsString:searchString];
    }
    else if (type == AdminUserRowInvites) {
//        query = [PFQuery queryWithClassName:@"Invite"];
//        [query whereKey:@"nome" containsString:searchString.uppercaseString];
    }

    [query findObjectsInBackgroundWithBlock:^(NSArray * _Nullable objects, NSError * _Nullable error) {

        for (PFUser *user in objects) {
            [self.logString appendAttributedString:[self appendSeparator:user.description]];
        }

        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1]
                      withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
}

- (NSAttributedString *)appendSeparator:(NSString *)string {

    NSAttributedString *separator = [[NSAttributedString alloc]
                                     initWithString:@"\n===========================================\n"
                                     attributes:@{NSForegroundColorAttributeName: [UIColor infoColor]}];
    NSAttributedString *inputText = [[NSAttributedString alloc]
                                     initWithString:string
                                     attributes:@{NSForegroundColorAttributeName: [UIColor warnColor]}];

    NSMutableAttributedString *fullText = [[NSMutableAttributedString alloc] initWithAttributedString:separator];
    [fullText appendAttributedString:inputText];

    return fullText;
}

@end
