//
//  DBManager.m
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "DBManager.h"
#import "MNNota+Persistence.h"
#import "MNFalta+Persistence.h"
#import "MNHorario+Persistence.h"
#import "MNCalendario+Persistence.h"
#import "MNAc+Persistence.h"

NSString * const DBManagerWillUpdateNotification = @"DBManagerWillUpdateNotification";
NSString * const DBManagerDidUpdateNotification = @"DBManagerDidUpdateNotification";

@implementation DBManager

static DBManager *SINGLETON = nil;

static bool isFirstAccess = YES;

#pragma mark - Public Method

+ (id)sharedInstance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        isFirstAccess = NO;
        SINGLETON = [[super allocWithZone:NULL] init];    
    });
    
    return SINGLETON;
}

- (id) init {

    if(SINGLETON){
        return SINGLETON;
    }
    if (isFirstAccess) {
        [self doesNotRecognizeSelector:_cmd];
    }
    self = [super init];

    if (self) {

        _database = [[YapDatabase alloc] initWithPath:[GeneralHelper pathForDBFile]];

        [MNNota registerViewsInDatabase:self.database];
        [MNFalta registerViewsInDatabase:self.database];
        [MNHorario registerViewsInDatabase:self.database];
        [MNCalendario registerViewsInDatabase:self.database];
        [MNAc registerViewsInDatabase:self.database];

        _uiConnection = [_database newConnection];
        _uiConnection.name = @"uiConnection";

        _rwConnection = [_database newConnection];
        _rwConnection.name = @"rwConnection";

        [[NSNotificationCenter defaultCenter]
         addObserver:self
         selector:@selector(yapDatabaseModified:)
         name:YapDatabaseModifiedNotification
         object:_database];
    }

    return self;
}
#pragma mark - Public Methods

+ (void)clearAllData {

    [[DBManager sharedInstance].rwConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction * transaction) {
        [transaction removeAllObjectsInAllCollections];
    }];
}

+ (BOOL)shouldUpdateModel:(NSString *)modelClass
             withMappings:(YapDatabaseViewMappings *)mappings {

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *lastUpdate;
    BOOL shouldUpdate = NO;

    if ([modelClass isEqualToString:NSStringFromClass([MNNota class])]) {

        lastUpdate = [defaults objectForKey:LAST_UPDATE_NOTAS];

        shouldUpdate = lastUpdate ? fabs([lastUpdate timeIntervalSinceNow]) > CACHE_TIME_NOTAS : YES;

        shouldUpdate = [mappings numberOfItemsInAllGroups] == 0 ?: shouldUpdate;
    }
    else if ([modelClass isEqualToString:NSStringFromClass([MNHorario class])]) {

        lastUpdate = [defaults objectForKey:LAST_UPDATE_HORARIO];

        shouldUpdate = lastUpdate ? fabs([lastUpdate timeIntervalSinceNow]) > CACHE_TIME_HORARIO : YES;

        shouldUpdate = [mappings numberOfItemsInAllGroups] == 0 ?: shouldUpdate;
    }
    else if ([modelClass isEqualToString:NSStringFromClass([MNCalendario class])]) {

        lastUpdate = [defaults objectForKey:LAST_UPDATE_CALENDARIO];

        shouldUpdate = lastUpdate ? fabs([lastUpdate timeIntervalSinceNow]) > CACHE_TIME_CALENDARIO : YES;

        shouldUpdate = [mappings numberOfItemsInAllGroups] == 0 ?: shouldUpdate;
    }
    else if ([modelClass isEqualToString:NSStringFromClass([MNAc class])]) {

        lastUpdate = [defaults objectForKey:LAST_UPDATE_AC];

        shouldUpdate = lastUpdate ? fabs([lastUpdate timeIntervalSinceNow]) > CACHE_TIME_AC : YES;

        shouldUpdate = [mappings numberOfItemsInAllGroups] == 0 ?: shouldUpdate;
    }

    return shouldUpdate;
}

#pragma mark - Notification Center

- (void)yapDatabaseModified:(NSNotification *)notification {

    // Notify observers we're about to update the database connection

    [[NSNotificationCenter defaultCenter] postNotificationName:DBManagerWillUpdateNotification object:self];

    // Move uiDatabaseConnection to the latest commit.
    // Do so atomically, and fetch all the notifications for each commit we jump.

    NSArray *notifications = [self.uiConnection beginLongLivedReadTransaction];

    // Notify observers that the uiDatabaseConnection was updated

    NSDictionary *userInfo = @{ @"notifications": notifications };

    [[NSNotificationCenter defaultCenter]
     postNotificationName:DBManagerDidUpdateNotification
     object:self
     userInfo:userInfo];
}

#pragma mark - Life Cycle

+ (id) allocWithZone:(NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)copyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

+ (id)mutableCopyWithZone:(struct _NSZone *)zone
{
    return [self sharedInstance];
}

- (id)copy
{
    return [[DBManager alloc] init];
}

- (id)mutableCopy
{
    return [[DBManager alloc] init];
}




@end
