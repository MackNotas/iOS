//
//  MNCalendario.h
//  MackNotas
//
//  Created by Caio Remedio on 29/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNModel.h"

@interface MNCalendario : MNModel <NSCopying, NSCoding>

@property (nonatomic) NSString *materia;
@property (nonatomic) NSString *data;
@property (nonatomic) NSString *tipo;
@property (nonatomic) NSString *dia;
@property (nonatomic) NSString *diaSemana;
@property (nonatomic) NSString *mesNumero;


@end
