//
//  MNAc.m
//  MackNotas
//
//  Created by Caio Remedio on 30/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNAc.h"

@implementation MNAc

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];

    if (self) {
        _id = [aDecoder decodeObjectForKey:@"id"];
        _tipo = [aDecoder decodeObjectForKey:@"tipo"];
        _tipo_ativ = [aDecoder decodeObjectForKey:@"tipo_ativ"];
        _data = [aDecoder decodeObjectForKey:@"data"];
        _modalidade = [aDecoder decodeObjectForKey:@"modalidade"];
        _assunto = [aDecoder decodeObjectForKey:@"assunto"];
        _anoSemestre = [aDecoder decodeObjectForKey:@"anoSemestre"];
        _horas = [aDecoder decodeObjectForKey:@"horas"];
        _atEnsino = [aDecoder decodeObjectForKey:@"atEnsino"];
        _atPesquisa = [aDecoder decodeObjectForKey:@"atPesquisa"];
        _atExtensao = [aDecoder decodeObjectForKey:@"atExtensao"];
        _excedentes = [aDecoder decodeObjectForKey:@"excedentes"];
        _total = [aDecoder decodeObjectForKey:@"total"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.tipo forKey:@"tipo"];
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.tipo_ativ forKey:@"tipo_ativ"];
    [aCoder encodeObject:self.modalidade forKey:@"modalidade"];
    [aCoder encodeObject:self.assunto forKey:@"assunto"];
    [aCoder encodeObject:self.anoSemestre forKey:@"anoSemestre"];
    [aCoder encodeObject:self.horas forKey:@"horas"];
    [aCoder encodeObject:self.atEnsino forKey:@"atEnsino"];
    [aCoder encodeObject:self.atPesquisa forKey:@"atPesquisa"];
    [aCoder encodeObject:self.atExtensao forKey:@"atExtensao"];
    [aCoder encodeObject:self.excedentes forKey:@"excedentes"];
    [aCoder encodeObject:self.total forKey:@"total"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {

    MNAc *copy = [MNAc new];
    copy.id = self.id;
    copy.tipo = self.tipo;
    copy.tipo_ativ = self.tipo_ativ;
    copy.data = self.data;
    copy.modalidade = self.modalidade;
    copy.assunto = self.assunto;
    copy.anoSemestre = self.anoSemestre;
    copy.horas = self.horas;
    copy.atEnsino = self.atEnsino;
    copy.atPesquisa = self.atPesquisa;
    copy.atExtensao = self.atExtensao;
    copy.excedentes = self.excedentes;
    copy.total = self.total;
    return copy;
}

#pragma mark - MNModel

- (void)updateWithResponseDictionary:(NSDictionary *)dictionary {

    if ([dictionary[@"id"] isEqualToNumber:@-1]) {
        self.tipo = @(MNAcTipoTotalHoras);
        self.id = dictionary[@"id"];
        self.atEnsino = dictionary[@"atEnsino"];
        self.atPesquisa = dictionary[@"atPesquisa"];
        self.atExtensao = dictionary[@"atExtensao"];
        self.excedentes = dictionary[@"excedentes"];
        self.total = dictionary[@"total"];
    }
    else {
        self.id = dictionary[@"id"];
        self.tipo = @(MNAcTipoAtivDeferidas);
        self.tipo_ativ = dictionary[@"tipo"];
        self.data = dictionary[@"data"];
        self.modalidade = dictionary[@"modalidade"];
        self.assunto = dictionary[@"assunto"];
        self.anoSemestre = dictionary[@"anoSemestre"];
        self.horas = dictionary[@"horas"];
    }
}

@end
