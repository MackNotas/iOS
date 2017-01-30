//
//  SettingsViewController.h
//  MackNotas
//
//  Created by Caio Remedio on 29/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

@interface SettingsViewController : UIViewController

FOUNDATION_EXPORT NSString * const kSettingsViewControllerWillLogoutUserNotification;
FOUNDATION_EXPORT NSString * const kSettingsViewControllerDidLoginUserNotification;

typedef NS_ENUM(NSInteger, SettingsSection) {
    SettingsSectionLogout = 0,
    SettingsSectionServerStatus,
    SettingsSectionNotification,
    SettingsSectionContact,
    SettingsSectionCount
};

typedef NS_ENUM(NSInteger, SettingsServerStatusRow) {
    SettingsServerStatusRowTIA = 0,
    SettingsServerStatusRowWS,
    SettingsServerStatusRowWSPush,
    SettingsServerStatusRowCount
};

typedef NS_ENUM(NSInteger, SettingsNotificationRow) {
    SettingsNotificationRowFullNota = 0,
    SettingsNotificationRowPushOnce,
    SettingsNotificationRowInvite,
    SettingsNotificationRowCount
};

typedef NS_ENUM(NSInteger, SettingsContactRow) {
    SettingsContactRowContact = 0,
//    SettingsContactRowInvite,
    SettingsContactRowTwitter,
//    SettingsContactRowPrivacy,
    SettingsContactRowAbout,
    SettingsContactRowCount
};

- (void)notificationSwitcherOption:(UISwitch *)switcher;

@end
