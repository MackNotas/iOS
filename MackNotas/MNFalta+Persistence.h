//
//  MNFalta+Persistence.h
//  MackNotas
//
//  Created by Caio Remedio on 24/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNFalta.h"
#import "DBManager.h"

FOUNDATION_EXPORT NSString * const MNFaltaGroupName;
FOUNDATION_EXPORT NSString * const MNFaltaViewName;

@interface MNFalta (Persistence) <Persistable>

+ (void)saveFaltasFromResponse:(id)response;
+ (void)removeAll;

@end
