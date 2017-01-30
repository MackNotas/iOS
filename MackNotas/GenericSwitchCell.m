//
//  GenericSwitchCell.m
//  MackNotas
//
//  Created by Caio Remedio on 01/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "GenericSwitchCell.h"
#import "SettingsViewController.h"

@implementation GenericSwitchCell

- (void)awakeFromNib {

    self.arrayTitles = @[@"Mostrar a nota na notificação",
                         @"Receber uma vez a notificação da mesma nota"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithTitleForRow:(NSInteger)row andTarget:(id)target {

    self.lblTitle.text = self.arrayTitles[row];

    self.swtichOption.tag = row;
    [self.swtichOption addTarget:(SettingsViewController *)target action:@selector(notificationSwitcherOption:) forControlEvents:UIControlEventValueChanged];

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser && row == SettingsNotificationRowFullNota) {
        NSNumber *optionStatus = currentUser[@"showNota"];
        [self.swtichOption setOn:optionStatus.boolValue animated:YES];
    }
    else if (currentUser && row == SettingsNotificationRowPushOnce) {
        NSNumber *optionStatus = currentUser[@"pushOnlyOnce"];
        [self.swtichOption setOn:optionStatus.boolValue animated:YES];
    }
}

@end
