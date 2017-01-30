//
//  MNNota.m
//  MackNotas
//
//  Created by Caio Remedio on 23/07/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNNota.h"

@implementation MNNota

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {

    self = [super init];

    if (self) {
        _notas = [aDecoder decodeObjectForKey:@"notas"];
        _materia = [aDecoder decodeObjectForKey:@"materia"];
        _formulas = [aDecoder decodeObjectForKey:@"formulas"];
        _id= [aDecoder decodeObjectForKey:@"id"];
        _falta = [aDecoder decodeObjectForKey:@"falta"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {

    [aCoder encodeObject:self.notas forKey:@"notas"];
    [aCoder encodeObject:self.materia forKey:@"materia"];
    [aCoder encodeObject:self.formulas forKey:@"formulas"];
    [aCoder encodeObject:self.id forKey:@"id"];
    [aCoder encodeObject:self.falta forKey:@"falta"];
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {

    MNNota *copy = [MNNota new];
    copy.notas = self.notas;
    copy.materia = self.materia;
    copy.formulas = self.formulas;
    copy.id = self.id;
    copy.falta = self.falta;

    return copy;
}

#pragma mark - MNModel

- (void)updateWithResponseDictionary:(NSDictionary *)dictionary {

    self.notas = dictionary[@"notas_new"];
    self.materia = dictionary[@"nome"];
    self.formulas = dictionary[@"formulas"];
    self.id = dictionary[@"id"];
}

#pragma mark - Propertie Override

- (BOOL)hasFalta {

    return self.falta;
}

@end
