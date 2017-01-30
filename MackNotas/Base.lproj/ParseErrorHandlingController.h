//
//  ParseErrorHandlingController.h
//  MackNotas
//
//  Created by Caio Remedio on 18/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginViewController.h"

@interface ParseErrorHandlingController : NSObject

+ (void)handleParseError:(NSError *)error;

@end

