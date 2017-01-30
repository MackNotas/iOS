//
//  MNAc.h
//  MackNotas
//
//  Created by Caio Remedio on 30/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNModel.h"

typedef enum : NSUInteger {
    MNAcTipoAtivDeferidas = 0,
    MNAcTipoTotalHoras
} MNAcTipo;

@interface MNAc : MNModel <NSCopying, NSCoding>

@property (nonatomic) NSNumber *tipo;
@property (nonatomic) NSNumber *id;

//
//  Atividades Deferidas
//
@property (nonatomic) NSString *tipo_ativ;
@property (nonatomic) NSString *data;
@property (nonatomic) NSString *modalidade;
@property (nonatomic) NSString *assunto;
@property (nonatomic) NSString *anoSemestre;
@property (nonatomic) NSString *horas;

//
//  Total Horas
//
@property (nonatomic) NSString *atEnsino;
@property (nonatomic) NSString *atPesquisa;
@property (nonatomic) NSString *atExtensao;
@property (nonatomic) NSString *excedentes;
@property (nonatomic) NSString *total;

@end
