//
//  MNNota.h
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNModel.h"

@class MNFalta;

@interface MNNota : MNModel <NSCopying, NSCoding>

@property (nonatomic) NSDictionary *notas;
@property (nonatomic) NSString *materia;
@property (nonatomic) NSArray *formulas;
@property (nonatomic) NSNumber *id;
@property (nonatomic) MNFalta *falta;

@property (nonatomic, readonly) BOOL hasFalta;

@end
