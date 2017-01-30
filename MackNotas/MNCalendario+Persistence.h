//
//  MNCalendario+Persistence.h
//  MackNotas
//
//  Created by Caio Remedio on 29/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNCalendario.h"
#import "DBManager.h"

FOUNDATION_EXPORT NSString * const MNCalendarioViewName;

@interface MNCalendario (Persistence) <Persistable>

+ (void)saveCalendarioFromResponse:(id)response;
+ (void)clearAllData;
+ (NSArray *)groupsName;

@end
