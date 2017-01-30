//
//  AppDelegate.m
//  MackNotas
//
//  Created by Caio Remedio on 16/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "AppDelegate.h"

//Frameworks
#import <Crashlytics/Crashlytics.h>
#import <Fabric/Fabric.h>
#import <Google/Analytics.h>

//Controllers
#import "LoginViewController.h"
#import "NotasViewController.h"
#import "SettingsViewController.h"
#import "AcViewController.h"
#import "CalendarioProvasViewController.h"
#import "HorarioContainerViewController.h"

//Helpers
#import "LocalUser.h"
#import "DDTTYLogger.h"
#import "ConnectionHelper.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [self initializeNotificationCenter];
    [self initializeParseWithLaunchOptions:launchOptions];
    [self initializeFabric];
    [self initializePushNotificationWithApplication:application];
    [self initializeCocoaLumberjack];
    [self initializeLoggedUser];
    [self initializeCacheSize];
    [self initializeUserDefaults];
    [self initializeGA];
    [self resetForNewVersionIfNeeded];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor vermelhoMainBackground];

    [self initializeRootViewController];

    [self.window makeKeyAndVisible];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[ConnectionHelper sharedClient] cancelAllRequests];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[ConnectionHelper sharedClient] cancelAllRequests];
}

- (void)applicationWillEnterForeground:(UIApplication *)application { }

- (void)applicationDidBecomeActive:(UIApplication *)application { }

- (void)applicationWillTerminate:(UIApplication *)application {
    [[ConnectionHelper sharedClient] cancelAllRequests];
}

#pragma mark - Init Methods

- (void)initializeCocoaLumberjack {

    [DDLog addLogger:[DDTTYLogger sharedInstance]];

    [DDTTYLogger sharedInstance].colorsEnabled = YES;

    //Verde Escuro
    [[DDTTYLogger sharedInstance]
     setForegroundColor:[UIColor infoColor]
     backgroundColor:nil
     forFlag:LOG_FLAG_INFO];

    //Azul Escuro
    [[DDTTYLogger sharedInstance]
     setForegroundColor:[UIColor verboseColor]
     backgroundColor:nil
     forFlag:LOG_FLAG_VERBOSE];

    //Bege
    [[DDTTYLogger sharedInstance]
     setForegroundColor:[UIColor debugColor]
     backgroundColor:nil
     forFlag:LOG_FLAG_DEBUG];

    //Roxo
    [[DDTTYLogger sharedInstance]
     setForegroundColor:[UIColor warnColor]
     backgroundColor:nil
     forFlag:LOG_FLAG_WARN];
}

- (void)initializeLoggedUser {

    PFUser *currentUser = [PFUser currentUser];

    if (currentUser) {
        LocalUser *localUser = [LocalUser sharedInstance];
        localUser = [NSKeyedUnarchiver unarchiveObjectWithFile:[GeneralHelper
                                                                pathForUserDataFile]];
    }
}

- (void)initializeCacheSize {

    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
}

- (void)initializeUserDefaults {

//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//
//    if (![defaults objectForKey:LAST_UPDATE_NOTAS]) {
//        [defaults setObject:[NSDate date] forKey:LAST_UPDATE_NOTAS];
//    }
}

- (void)initializeGA {

    // Configure tracker from GoogleService-Info.plist.
    NSError *configureError;
    [[GGLContext sharedInstance] configureWithError:&configureError];
    NSAssert(!configureError, @"Error configuring Google services: %@", configureError);

    // Optional: configure GAI options.
    GAI *gai = [GAI sharedInstance];
    gai.trackUncaughtExceptions = YES;  // report uncaught exceptions
    gai.logger.logLevel = kGAILogLevelError;  // remove before app release
#if TARGET_IPHONE_SIMULATOR 
    gai.dryRun = YES;
#endif
}

- (void)initializeRootViewController {

    PFUser *currentUser = [PFUser currentUser];
    UIViewController *viewController;

    if (currentUser) {

        MNTabBarController *tabbar = [MNTabBarController new];

        MNNavigationController *navNotas = [[MNNavigationController alloc]
                                            initWithRootViewController:[NotasViewController new]];

        MNNavigationController *navSettings = [[MNNavigationController alloc]
                                               initWithRootViewController:[SettingsViewController new]];

        if ([[[NSUserDefaults standardUserDefaults] objectForKey:SETTINGS_IS_EM] isEqualToNumber:@YES]) {
            tabbar.viewControllers = @[navNotas,
                                       navSettings];
        }

        else {
            HorarioContainerViewController *viewHorario = [HorarioContainerViewController new];

            MNNavigationController *navCalendar = [[MNNavigationController alloc]
                                                   initWithRootViewController:[CalendarioProvasViewController new]];

            MNNavigationController *navAC = [[MNNavigationController alloc]
                                             initWithRootViewController:[AcViewController new]];
            tabbar.viewControllers = @[navNotas,
                                       viewHorario,
                                       navCalendar,
                                       navAC,
                                       navSettings];
        }
        viewController = tabbar;
    }
    else {
        viewController = [LoginViewController new];
    }

    self.window.rootViewController = viewController;
}

- (void)initializeParseWithLaunchOptions:(NSDictionary *)launchOptions {

    [Parse setApplicationId:PARSE_APPID
                  clientKey:PARSE_CLIENTID];

    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

- (void)initializeFabric {

    [Fabric with:@[CrashlyticsKit]];
}

- (void)initializeNotificationCenter {

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogin:)
                                                 name:kSettingsViewControllerDidLoginUserNotification
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didLogout:)
                                                 name:kSettingsViewControllerWillLogoutUserNotification
                                               object:nil];
}

- (void)resetForNewVersionIfNeeded {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *currentVersion =  [[NSBundle mainBundle]
                                 objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *savedVersion = [defaults objectForKey:kDefaultsCurrentVersion];

    if (![savedVersion isEqualToString:currentVersion]) {
        [defaults setObject:currentVersion forKey:kDefaultsCurrentVersion];
        [defaults synchronize];
        [LocalUser logout];
    }
}

#pragma mark - NotificationCenter Methods

- (void)didLogin:(NSNotification *)notification {

    [self initializeRootViewController];
}

- (void)didLogout:(NSNotification *)notification {

    if ([notification.object isKindOfClass:[SettingsViewController class]]) {
        [self initializeRootViewController];
    }
}

#pragma mark - Push Notification Methods

- (void)initializePushNotificationWithApplication:(UIApplication *)application {
    
    if ([application respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationType userNotificationTypes = (UIUserNotificationTypeAlert |
                                                        UIUserNotificationTypeBadge |
                                                        UIUserNotificationTypeSound);
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:userNotificationTypes
                                                                                 categories:nil];
        [application registerUserNotificationSettings:settings];
        [application registerForRemoteNotifications];
    } else {
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes: (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    }
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {

    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    PFUser *user = [PFUser currentUser];

    [currentInstallation setDeviceTokenFromData:deviceToken];

    if (user) {
        currentInstallation[@"user"] = user;
        currentInstallation.channels = @[fstr(@"t%@",user.username)];
        [[Crashlytics sharedInstance] setUserName:user.username];
    }
    if (currentInstallation.deviceToken) {
        [currentInstallation saveInBackground];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {

    [PFPush handlePush:userInfo];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}


@end