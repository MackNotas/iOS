//
//  MNNota+Persistence.m
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNNota+Persistence.h"
#import "MNFalta.h"

NSString * const MNotaGroupName = @"notas";
NSString * const MNotaViewName = @"notasView";

@implementation MNNota (Persistence)

- (NSString *)key {

    return self.id.stringValue;
}

+ (NSString *)collectionKey {

    return @"notas";
}

+ (void)saveNotasFromResponseArray:(NSArray *)respArray {

    [[DBManager sharedInstance].rwConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {

        NSArray *newNotas = [MNNota modelsFromResponseArray:respArray];
        NSInteger currentNumberOfKeys = [transaction numberOfKeysInCollection:[MNNota collectionKey]];

        if (newNotas.count < currentNumberOfKeys) {
            [self removeNonexistentOldNotasWithNewSize:newNotas.count
                                            andOldSize:currentNumberOfKeys
                                        andTransaction:transaction];
        }

        for (MNNota *newNota in newNotas) {
            [self mergeNewNota:newNota
               withTransaction:transaction];
        }
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:LAST_UPDATE_NOTAS];
}

+ (void)registerViewsInDatabase:(YapDatabase *)database {

    YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(NSString *collection, NSString *key, id object) {

        if ([collection isEqualToString:[self collectionKey]] &&
             [object isKindOfClass:[MNNota class]]) {
            return MNotaGroupName;
        }
        return nil;
    }];

    YapDatabaseViewSorting *sorting =
    [YapDatabaseViewSorting
     withObjectBlock:^NSComparisonResult(NSString *group,
                                         NSString *collection1,
                                         NSString *key1,
                                         MNNota *object1,
                                         NSString *collection2,
                                         NSString *key2,
                                         MNNota *object2) {

         return NSOrderedSame;
     }];

    [database registerExtension:[[YapDatabaseView alloc] initWithGrouping:grouping
                                                                  sorting:sorting]
                       withName:MNotaViewName];
}

+ (void)removeAll {

    [[DBManager sharedInstance].rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * transaction) {
        [transaction removeAllObjectsInCollection:[MNNota collectionKey]];
    }];
}

+ (void)updateFaltaWithFalta:(MNFalta *)falta
              andTransaction:(YapDatabaseReadWriteTransaction *)transaction {

    [[transaction ext:MNotaViewName]
     enumerateKeysAndObjectsInGroup:MNotaGroupName
     usingBlock:^(NSString *collection, NSString *key, MNNota *nota, NSUInteger index, BOOL *stop) {

         MNNota *notaWithFalta = nota.copy;

         if ([notaWithFalta.materia isEqualToString:falta.materia]) {
             notaWithFalta.falta = falta;
             [transaction replaceObject:notaWithFalta
                                 forKey:notaWithFalta.key
                           inCollection:[MNNota collectionKey]];
             *stop = YES;
         }
     }];

}

#pragma mark - Private Methods

+ (void)mergeNewNota:(MNNota *)newNota
     withTransaction:(YapDatabaseReadWriteTransaction *)transaction {

    MNNota *oldNota = [transaction objectForKey:newNota.key
                                   inCollection:[MNNota collectionKey]];

    if (!oldNota) {
        [transaction setObject:newNota
                        forKey:newNota.key
                  inCollection:[MNNota collectionKey]];
        return;
    }

    BOOL hasChange = NO;

    if (![oldNota.notas isEqualToDictionary:newNota.notas]) {
        oldNota.notas = newNota.notas;
        hasChange = YES;
    }
    if (![oldNota.formulas isEqualToArray:newNota.formulas]) {
        oldNota.formulas = newNota.formulas;
        hasChange = YES;
    }
    if (![oldNota.materia isEqualToString:newNota.materia]) {
        oldNota.materia = newNota.materia;
        hasChange = YES;
    }
    if (hasChange) {
        [transaction replaceObject:oldNota
                            forKey:oldNota.key
                      inCollection:[MNNota collectionKey]];
    }

}

+ (void)removeNonexistentOldNotasWithNewSize:(NSInteger)newSize
                                  andOldSize:(NSInteger)oldSize
                              andTransaction:(YapDatabaseReadWriteTransaction *)transaction {

    for (NSInteger i = newSize; i < oldSize; i++) {
        [transaction removeObjectForKey:fstr(@"%ld",(long)i)
                           inCollection:[MNNota collectionKey]];
    }
}

@end
