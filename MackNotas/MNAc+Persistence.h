//
//  MNAc+Persistence.h
//  MackNotas
//
//  Created by Caio Remedio on 30/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNAc.h"
#import "DBManager.h"

FOUNDATION_EXPORT NSString * const MNACViewName;
FOUNDATION_EXPORT NSString * const MNACTotalHorasGroup;
FOUNDATION_EXPORT NSString * const MNACAtivDeferidasGroup;

@interface MNAc (Persistence) <Persistable>

+ (void)saveACFromResponse:(id)response;
+ (void)clearAllData;
+ (NSArray *)groupsName;

@end
