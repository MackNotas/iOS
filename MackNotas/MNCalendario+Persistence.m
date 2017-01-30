//
//  MNCalendario+Persistence.m
//  MackNotas
//
//  Created by Caio Remedio on 29/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNCalendario+Persistence.h"

NSString * const MNCalendarioViewName = @"calendarioView";

@implementation MNCalendario (Persistence)

- (NSString *)key {

    return fstr(@"%@%@", self.materia, self.tipo);
}

+ (NSString *)collectionKey {

    return @"horarios";
}

+ (NSArray *)groupsName {

    return [GeneralHelper isOnFirstSemester] ? @[@"1",@"2",@"3",@"4",@"5",@"6",@"7"] : @[@"8",@"9",@"10",@"11",@"12"];
}

+ (void)saveCalendarioFromResponse:(id)response {

    [[DBManager sharedInstance].rwConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {

        if ([response isKindOfClass:[NSArray class]]) {

            for (NSArray *arrayWithDics in response) {
                if (arrayWithDics.count == 0) {
                    continue;
                }

                NSArray *newFaltas = [MNCalendario modelsFromResponseArray:arrayWithDics];

                for (MNCalendario *newCal in newFaltas) {
                    [self mergeNewCalendario:newCal
                              andTransaction:transaction];
                }
            }
        }
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:LAST_UPDATE_CALENDARIO];
}

+ (void)registerViewsInDatabase:(YapDatabase *)database {

    YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(NSString *collection,
                                                                                             NSString *key,
                                                                                             id object) {
        if ([object isKindOfClass:[MNCalendario class]]) {
            NSInteger mesNumero = [[object mesNumero] integerValue];
            NSString *groupName;

            switch (mesNumero) {
                case 1:
                    groupName = @"1";
                    break;
                case 2:
                    groupName = @"2";
                    break;
                case 3:
                    groupName = @"3";
                    break;
                case 4:
                    groupName = @"4";
                    break;
                case 5:
                    groupName = @"5";
                    break;
                case 6:
                    groupName = @"6";
                    break;
                case 7:
                    groupName = @"7";
                    break;
                case 8:
                    groupName = @"8";
                    break;
                case 9:
                    groupName = @"9";
                    break;
                case 10:
                    groupName = @"10";
                    break;
                case 11:
                    groupName = @"11";
                    break;
                case 12:
                    groupName = @"12";
                    break;
                default:
                    groupName = @"default";
                    break;
            }
            return groupName;
        }
        return nil;
    }];

    YapDatabaseViewSorting *sorting =
    [YapDatabaseViewSorting
     withObjectBlock:^NSComparisonResult(NSString *group,
                                         NSString *collection1,
                                         NSString *key1,
                                         MNCalendario *object1,
                                         NSString *collection2,
                                         NSString *key2,
                                         MNCalendario *object2) {

         return NSOrderedSame;
     }];

    [database registerExtension:[[YapDatabaseView alloc] initWithGrouping:grouping
                                                                  sorting:sorting]
                       withName:MNCalendarioViewName];
}

+ (void)clearAllData {

    [[DBManager sharedInstance].rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction removeAllObjectsInCollection:[self collectionKey]];
    }];
}

#pragma mark - Private Methods

+ (void)mergeNewCalendario:(MNCalendario *)newCal
            andTransaction:(YapDatabaseReadWriteTransaction *)transaction {

    MNCalendario *oldCalendario = [transaction objectForKey:newCal.key
                                               inCollection:[MNCalendario collectionKey]];

    if (!oldCalendario) {
        [transaction setObject:newCal
                        forKey:newCal.key
                  inCollection:[MNCalendario collectionKey]];
    }

    else if (![oldCalendario.materia isEqualToString:newCal.materia]        ||
             ![oldCalendario.data isEqualToString:newCal.data]              ||
             ![oldCalendario.tipo isEqualToString:newCal.tipo]              ||
             ![oldCalendario.dia isEqualToString:newCal.dia]                ||
             ![oldCalendario.diaSemana isEqualToString:newCal.diaSemana]    ||
             ![oldCalendario.mesNumero isEqualToString:newCal.mesNumero]) {

        [transaction replaceObject:newCal
                            forKey:newCal.key
                      inCollection:[MNCalendario collectionKey]];
    }
}

@end
