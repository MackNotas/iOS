//
//  MNNota+Persistence.h
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNNota.h"
#import "DBManager.h"

FOUNDATION_EXPORT NSString * const MNotaGroupName;
FOUNDATION_EXPORT NSString * const MNotaViewName;

@interface MNNota (Persistence) <Persistable>

+ (void)saveNotasFromResponseArray:(NSArray *)respArray;
+ (void)removeAll;
+ (void)updateFaltaWithFalta:(MNFalta *)falta
              andTransaction:(YapDatabaseReadWriteTransaction *)transaction;

@end
