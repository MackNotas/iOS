//
//  MNModel.h
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MNModel : NSObject

+ (NSArray *)modelsFromResponseArray:(NSArray *)responseArray;

+ (instancetype)modelFromResponseDictionary:(NSDictionary *)dictionary;

- (void)updateWithResponseDictionary:(NSDictionary *)dictionary;
- (void)updateWithResponseArray:(NSArray *)array;

@end
