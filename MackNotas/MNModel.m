//
//  MNModel.m
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNModel.h"

@implementation MNModel

+ (NSArray *)modelsFromResponseArray:(NSArray *)responseArray  {

    if (![responseArray isKindOfClass:[NSArray class]]) {
        return nil;
    }

    NSMutableArray *models = [NSMutableArray arrayWithCapacity:responseArray.count];

    for (NSDictionary *dictionary in responseArray) {
        id model = [self modelFromResponseDictionary:dictionary];
        if (model) {
            [models addObject:model];
        }
    }

    return models;
}

+ (instancetype)modelFromResponseDictionary:(NSDictionary *)dictionary {

    if (![dictionary isKindOfClass:[NSDictionary class]]) {
        return nil;
    }

    MNModel *model = [self new];
    [model updateWithResponseDictionary:dictionary];

    return model;
}

- (void)updateWithResponseDictionary:(NSDictionary *)dictionary {

}

- (void)updateWithResponseArray:(NSArray *)array {

}

@end
