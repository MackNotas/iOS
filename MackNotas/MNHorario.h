//
//  MNHorario.h
//  MackNotas
//
//  Created by Caio Remedio on 24/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNModel.h"

@interface MNHorario : MNModel <NSCopying, NSCoding>

@property (nonatomic) NSArray *horas;
@property (nonatomic) NSArray *materias;
@property (nonatomic) NSNumber *dia;
@property (nonatomic) NSNumber *valido;

@property (nonatomic, readonly) BOOL isValid;

@end
