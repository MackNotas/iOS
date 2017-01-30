//
//  MNHorario.m
//  MackNotas
//
//  Created by Caio Remedio on 24/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNHorario.h"

@implementation MNHorario

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];

    if (self) {
        _horas = [aDecoder decodeObjectForKey:@"horas"];
        _materias = [aDecoder decodeObjectForKey:@"materias"];
        _dia = [aDecoder decodeObjectForKey:@"dia"];
        _valido = [aDecoder decodeObjectForKey:@"valido"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.horas forKey:@"horas"];
    [aCoder encodeObject:self.materias forKey:@"materias"];
    [aCoder encodeObject:self.dia forKey:@"dia"];
    [aCoder encodeObject:self.valido forKey:@"valido"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {

    MNHorario *copy = [MNHorario new];
    copy.horas = self.horas;
    copy.materias = self.materias;
    copy.dia = self.dia;
    copy.valido = self.valido;

    return copy;
}

#pragma mark - MNModel

- (void)updateWithResponseDictionary:(NSDictionary *)dictionary {

    self.materias = dictionary[@"materias"];
    self.horas = dictionary[@"horas"];
    self.dia = dictionary[@"dia"];
    self.valido = dictionary[@"isInvalid"] ? @(![dictionary[@"isInvalid"] boolValue]) : @YES;
}

#pragma mark - Propertie Override

- (BOOL)isValid {

    return self.valido.boolValue;
}

@end
