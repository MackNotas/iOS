//
//  Feedback.h
//  MackNotas
//
//  Created by Caio Remedio on 24/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <Parse/Parse.h>
#import "FeedbackFormViewController.h"

@interface Feedback : PFObject <PFSubclassing>

- (void)loadWithNomeCompleto:(NSString *)nomeCompleto
                    mensagem:(NSString *)mensagem
                       email:(NSString *)email
                  plataforma:(NSString *)plataforma
                  appVersion:(NSString *)appVersion
                   osVersion:(NSString *)osVersion
               modeloCelular:(NSString *)modeloCelular
                         TIA:(NSString *)TIA
                     andTipo:(FeedbackType)tipo;

@end
