//
//  Feedback.m
//  MackNotas
//
//  Created by Caio Remedio on 24/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "Feedback.h"
#import <PFObject+Subclass.h>

@interface Feedback ()

@property (nonatomic) NSString *nomeCompleto;
@property (nonatomic) NSString *mensagem;
@property (nonatomic) NSString *email;
@property (nonatomic) NSString *plataforma;
@property (nonatomic) NSString *appVersion;
@property (nonatomic) NSString *osVersion;
@property (nonatomic) NSString *modeloCelular;
@property (nonatomic) NSString *TIA;
@property (nonatomic) NSNumber *tipo;

@end

@implementation Feedback

@dynamic nomeCompleto;
@dynamic mensagem;
@dynamic plataforma;
@dynamic appVersion;
@dynamic osVersion;
@dynamic modeloCelular;
@dynamic TIA;
@dynamic tipo;
@dynamic email;

+ (void)load {

    [self registerSubclass];
}

+ (NSString *)parseClassName {

    return NSStringFromClass([Feedback class]);
}

- (void)loadWithNomeCompleto:(NSString *)nomeCompleto
                    mensagem:(NSString *)mensagem
                       email:(NSString *)email
                  plataforma:(NSString *)plataforma
                  appVersion:(NSString *)appVersion
                   osVersion:(NSString *)osVersion
               modeloCelular:(NSString *)modeloCelular
                         TIA:(NSString *)TIA
                     andTipo:(FeedbackType)tipo {

    self.nomeCompleto   = nomeCompleto;
    self.mensagem       = mensagem;
    self.email          = email;
    self.plataforma     = plataforma;
    self.appVersion     = appVersion;
    self.osVersion      = osVersion;
    self.modeloCelular  = modeloCelular;
    self.TIA            = TIA;
    self.tipo           = @(tipo);
}

@end
