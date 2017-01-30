//
//  MNFalta.h
//  MackNotas
//
//  Created by Caio Remedio on 24/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNModel.h"

@interface MNFalta : MNModel <NSCopying, NSCoding>

@property (nonatomic) NSString *materia;
@property (nonatomic) NSString *faltas;
@property (nonatomic) NSString *porcentagem;
@property (nonatomic) NSString *permitido;
@property (nonatomic) NSString *ultimaFalta;
@property (nonatomic) NSNumber *valido;

@property (nonatomic, readonly) BOOL isValid;

@end
