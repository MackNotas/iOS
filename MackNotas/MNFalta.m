//
//  MNFalta.m
//  MackNotas
//
//  Created by Caio Remedio on 24/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNFalta.h"

@implementation MNFalta

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];

    if (self) {
        _materia = [aDecoder decodeObjectForKey:@"materia"];
        _faltas = [aDecoder decodeObjectForKey:@"faltas"];
        _porcentagem = [aDecoder decodeObjectForKey:@"porcentagem"];
        _permitido = [aDecoder decodeObjectForKey:@"permitido"];
        _ultimaFalta = [aDecoder decodeObjectForKey:@"ultimaFalta"];
        _valido = [aDecoder decodeObjectForKey:@"valido"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.materia forKey:@"materia"];
    [aCoder encodeObject:self.faltas forKey:@"faltas"];
    [aCoder encodeObject:self.porcentagem forKey:@"porcentagem"];
    [aCoder encodeObject:self.permitido forKey:@"permitido"];
    [aCoder encodeObject:self.ultimaFalta forKey:@"ultimaFalta"];
    [aCoder encodeObject:self.valido forKey:@"valido"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {

    MNFalta *copy = [MNFalta new];
    copy.materia = self.materia;
    copy.faltas = self.faltas;
    copy.porcentagem = self.porcentagem;
    copy.permitido = self.permitido;
    copy.ultimaFalta = self.ultimaFalta;
    copy.valido = self.valido;

    return copy;
}

#pragma mark - MNModel

- (void)updateWithResponseDictionary:(NSDictionary *)dictionary {

    self.materia = dictionary[@"nome"];
    self.faltas = dictionary[@"faltas"];
    self.porcentagem = dictionary[@"porcentagem"];
    self.permitido = dictionary[@"permitido"];
    self.ultimaFalta = dictionary[@"ultimaData"];
    self.valido = dictionary[@"isInvalid"] ? @(![dictionary[@"isInvalid"] boolValue]) : @YES;
}

#pragma mark - Propertie Override

- (BOOL)isValid {

    return self.valido.boolValue;
}

@end
