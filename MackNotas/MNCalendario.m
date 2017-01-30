//
//  MNCalendario.m
//  MackNotas
//
//  Created by Caio Remedio on 29/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNCalendario.h"

@implementation MNCalendario

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];

    if (self) {
        _materia = [aDecoder decodeObjectForKey:@"materia"];
        _data = [aDecoder decodeObjectForKey:@"data"];
        _tipo = [aDecoder decodeObjectForKey:@"tipo"];
        _dia = [aDecoder decodeObjectForKey:@"dia"];
        _diaSemana = [aDecoder decodeObjectForKey:@"diaSemana"];
        _mesNumero = [aDecoder decodeObjectForKey:@"mesNumero"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.materia forKey:@"materia"];
    [aCoder encodeObject:self.data forKey:@"data"];
    [aCoder encodeObject:self.tipo forKey:@"tipo"];
    [aCoder encodeObject:self.dia forKey:@"dia"];
    [aCoder encodeObject:self.diaSemana forKey:@"diaSemana"];
    [aCoder encodeObject:self.mesNumero forKey:@"mesNumero"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {

    MNCalendario *copy = [MNCalendario new];
    copy.materia = self.materia;
    copy.data = self.data;
    copy.tipo = self.tipo;
    copy.dia = self.dia;
    copy.diaSemana = self.diaSemana;
    copy.mesNumero = self.mesNumero;

    return copy;
}

#pragma mark - MNModel

- (void)updateWithResponseDictionary:(NSDictionary *)dictionary {

    self.materia = dictionary[@"materia"];
    self.data = dictionary[@"data"];
    self.tipo = dictionary[@"tipo"];
    self.dia = dictionary[@"dia"];
    self.diaSemana = dictionary[@"diaSemana"];
    self.mesNumero = dictionary[@"mesNumero"];
}

@end
