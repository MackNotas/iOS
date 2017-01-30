//
//  MNHorario+Persistence.m
//  MackNotas
//
//  Created by Caio Remedio on 25/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNHorario+Persistence.h"

NSString * const MNHorarioGroupName = @"horario";
NSString * const MNHorarioViewName = @"horarioView";

@implementation MNHorario (Persistence)

- (NSString *)key {

    return self.dia.stringValue ?: @"isInvalid";
}

+ (NSString *)collectionKey {

    return @"horarios";
}

+ (void)saveHorariosFromResponse:(id)response {

    [[DBManager sharedInstance].rwConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {

        if ([response isKindOfClass:[NSArray class]]) {
            NSArray *newFaltas = [MNHorario modelsFromResponseArray:response];

            for (MNHorario *newHorario in newFaltas) {
                [transaction setObject:newHorario
                                forKey:newHorario.key
                          inCollection:[MNHorario collectionKey]];
            }
        }
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:LAST_UPDATE_HORARIO];

}

+ (void)registerViewsInDatabase:(YapDatabase *)database {

    YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(NSString *collection,
                                                                                             NSString *key,
                                                                                             id object) {
        if ([collection isEqualToString:[self collectionKey]] &&
            [object isKindOfClass:[MNHorario class]]) {
            return MNHorarioGroupName;
        }
        return nil;
    }];

    YapDatabaseViewSorting *sorting =
    [YapDatabaseViewSorting
     withObjectBlock:^NSComparisonResult(NSString *group,
                                         NSString *collection1,
                                         NSString *key1,
                                         MNHorario *object1,
                                         NSString *collection2,
                                         NSString *key2,
                                         MNHorario *object2) {

         return NSOrderedSame;
     }];

    [database registerExtension:[[YapDatabaseView alloc] initWithGrouping:grouping
                                                                  sorting:sorting]
                       withName:MNHorarioViewName];
}

+ (void)clearAllData {

    [[DBManager sharedInstance].rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction removeAllObjectsInCollection:[self collectionKey]];
    }];
}

@end
