//
//  MNAc+Persistence.m
//  MackNotas
//
//  Created by Caio Remedio on 30/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNAc+Persistence.h"

NSString * const MNACTotalHorasGroup = @"totalHoras";
NSString * const MNACAtivDeferidasGroup = @"ativDeferidas";
NSString * const MNACViewName = @"acView";

@implementation MNAc (Persistence)

- (NSString *)key {

    return fstr(@"%@", self.id);
}

+ (NSString *)collectionKey {

    return @"ativComp";
}

+ (NSArray *)groupsName {

    return @[MNACTotalHorasGroup,
             MNACAtivDeferidasGroup];
}

+ (void)saveACFromResponse:(id)response {

    [[DBManager sharedInstance].rwConnection asyncReadWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {

        NSArray *ativDeferidas = [MNAc modelsFromResponseArray:response[@"atDeferidas"]];

        for (MNAc *newAC in ativDeferidas) {
            [self mergeNewAC:newAC andTransaction:transaction];
        }

        MNAc *totalHorasAc = [MNAc modelFromResponseDictionary:response[@"totalHoras"]];
        [self mergeNewAC:totalHorasAc andTransaction:transaction];
    }];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:LAST_UPDATE_AC];
}

+ (void)registerViewsInDatabase:(YapDatabase *)database {

    YapDatabaseViewGrouping *grouping = [YapDatabaseViewGrouping withObjectBlock:^NSString *(NSString *collection,
                                                                                             NSString *key,
                                                                                             id object) {
        if ([object isKindOfClass:[MNAc class]]) {
            NSInteger tipoAC = [[object tipo] integerValue];
            NSString *groupName;

            switch (tipoAC) {
                case MNAcTipoAtivDeferidas:
                    groupName = MNACAtivDeferidasGroup;
                    break;
                case MNAcTipoTotalHoras:
                    groupName = MNACTotalHorasGroup;
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
                                         MNAc *object1,
                                         NSString *collection2,
                                         NSString *key2,
                                         MNAc *object2) {

         return NSOrderedSame;
     }];

    [database registerExtension:[[YapDatabaseView alloc] initWithGrouping:grouping
                                                                  sorting:sorting]
                       withName:MNACViewName];
}

+ (void)clearAllData {

    [[DBManager sharedInstance].rwConnection readWriteWithBlock:^(YapDatabaseReadWriteTransaction *transaction) {
        [transaction removeAllObjectsInCollection:[self collectionKey]];
    }];
}

#pragma mark - Private Methods

+ (void)mergeNewAC:(MNAc *)newAC
    andTransaction:(YapDatabaseReadWriteTransaction *)transaction {

    MNAc *oldAC = [transaction objectForKey:newAC.key
                               inCollection:[MNAc collectionKey]];

    if (!oldAC) {
        [transaction setObject:newAC
                        forKey:newAC.key
                  inCollection:[MNAc collectionKey]];
    }

    else if ([newAC.tipo isEqualToNumber:@(MNAcTipoTotalHoras)]) {
        if (![oldAC.atEnsino isEqualToString:newAC.atEnsino]     ||
            ![oldAC.atPesquisa isEqualToString:newAC.atPesquisa] ||
            ![oldAC.atExtensao isEqualToString:newAC.atExtensao] ||
            ![oldAC.excedentes isEqualToString:newAC.excedentes] ||
            ![oldAC.total isEqualToString:newAC.total]) {

            [transaction replaceObject:newAC
                                forKey:newAC.key
                          inCollection:[MNAc collectionKey]];
        }
    }

    else if (![oldAC.tipo_ativ isEqualToString:newAC.tipo_ativ]     ||
             ![oldAC.data isEqualToString:newAC.data]               ||
             ![oldAC.modalidade isEqualToString:newAC.modalidade]   ||
             ![oldAC.assunto isEqualToString:newAC.assunto]         ||
             ![oldAC.anoSemestre isEqualToString:newAC.anoSemestre] ||
             ![oldAC.horas isEqualToString:newAC.horas]) {

        [transaction replaceObject:newAC
                            forKey:newAC.key
                      inCollection:[MNAc collectionKey]];
    }
}

@end
