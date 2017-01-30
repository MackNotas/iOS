//
//  MNFalta+Persistence.m
//  MackNotas
//
//  Created by Caio Remedio on 24/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNFalta+Persistence.h"
#import "MNNota+Persistence.h"

NSString * const MNFaltaGroupName = @"faltas";
NSString * const MNFaltaViewName = @"faltasView";

@implementation MNFalta (Persistence)

- (NSString *)key {

    return self.materia ?: @"isInvalid";
}

+ (NSString *)collectionKey {

    return @"faltas";
}

+ (void)saveFaltasFromResponse:(id)response {

    [[DBManager sharedInstance].rwConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {

        NSMutableArray *newFaltas = [NSMutableArray array];

        if ([response isKindOfClass:[NSArray class]]) {
            newFaltas = [MNFalta modelsFromResponseArray:response].mutableCopy;

            NSInteger currentNumberOfKeys = [transaction numberOfKeysInCollection:[MNFalta collectionKey]];

            if (newFaltas.count < currentNumberOfKeys) {
                [self removeNonexistentOldFaltasWithNewSize:newFaltas.count
                                                 andOldSize:currentNumberOfKeys
                                             andTransaction:transaction];
            }

        }

        for (MNFalta *newFalta in newFaltas) {
            [self mergeNewFalta:newFalta
                 andTransaction:transaction];
        }
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:LAST_UPDATE_FALTAS];
}

+ (void)registerViewsInDatabase:(YapDatabase *)database {

    YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(NSString *collection,
                                                                                             NSString *key,
                                                                                             id object) {
        if ([collection isEqualToString:[self collectionKey]] &&
            [object isKindOfClass:[MNFalta class]]) {
            return MNFaltaGroupName;
        }
        return nil;
    }];

    YapDatabaseViewSorting *sorting =
    [YapDatabaseViewSorting
     withObjectBlock:^NSComparisonResult(NSString *group,
                                         NSString *collection1,
                                         NSString *key1,
                                         MNFalta *object1,
                                         NSString *collection2,
                                         NSString *key2,
                                         MNFalta *object2) {

         return NSOrderedSame;
     }];

    [database registerExtension:[[YapDatabaseView alloc] initWithGrouping:grouping
                                                                  sorting:sorting]
                       withName:MNFaltaViewName];
}

+ (void)removeAll {

    [[DBManager sharedInstance].rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction * transaction) {

        if ([transaction numberOfKeysInCollection:[MNFalta collectionKey]] != 0) {
            NSMutableArray *changedNotas = [NSMutableArray array];

            [transaction
             enumerateKeysAndObjectsInCollection:[MNNota collectionKey]
             usingBlock:^(NSString *key, MNNota *nota, BOOL *stop) {
                 if (nota.falta) {
                     nota.falta = nil;
                     [changedNotas addObject:nota];
                 }
             }];

            for (MNNota *nota in changedNotas) {
                [transaction setObject:nota
                                forKey:nota.key
                          inCollection:[MNNota collectionKey]];
            }
            [transaction removeAllObjectsInCollection:[MNFalta collectionKey]];
        }
    }];
}

#pragma mark - Private Methods

+ (void)mergeNewFalta:(MNFalta *)newFalta andTransaction:(YapDatabaseReadWriteTransaction *)transaction {

    MNFalta *oldFalta = [transaction objectForKey:newFalta.key
                                     inCollection:[MNFalta collectionKey]];

    //
    // TODO: Adicionar as faltas já existentes, em uma Nota nova.
    //

    if ((![oldFalta.materia isEqualToString:newFalta.materia]           ||
        ![oldFalta.faltas isEqualToString:newFalta.faltas]              ||
        ![oldFalta.porcentagem isEqualToString:newFalta.porcentagem]    ||
        ![oldFalta.permitido isEqualToString:newFalta.permitido]        ||
        ![oldFalta.ultimaFalta isEqualToString:newFalta.ultimaFalta])   || !oldFalta) {

        [transaction setObject:newFalta
                        forKey:newFalta.key
                  inCollection:[MNFalta collectionKey]];

        [MNNota updateFaltaWithFalta:newFalta
                      andTransaction:transaction];
        
    }
}

+ (void)removeNonexistentOldFaltasWithNewSize:(NSInteger)newSize
                                   andOldSize:(NSInteger)oldSize
                               andTransaction:(YapDatabaseReadWriteTransaction *)transaction {

    for (NSInteger i = newSize; i < oldSize; i++) {
        [transaction removeObjectForKey:fstr(@"%ld",(long)i)
                           inCollection:[MNFalta collectionKey]];
    }
}

@end
