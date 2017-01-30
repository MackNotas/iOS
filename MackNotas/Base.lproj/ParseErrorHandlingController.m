//
//  ParseErrorHandlingController.m
//  MackNotas
//
//  Created by Caio Remedio on 18/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "ParseErrorHandlingController.h"

@implementation ParseErrorHandlingController

+ (void)handleParseError:(NSError *)error {
    if (![error.domain isEqualToString:PFParseErrorDomain]) {
        return;
    }

    switch (error.code) {
        case kPFErrorInvalidSessionToken: {
            [self _handleInvalidSessionTokenError];
            break;
        }
    }
}

+ (void)_handleInvalidSessionTokenError {

    UIViewController *presentingViewController = [UIApplication sharedApplication].keyWindow.rootViewController;

    LoginViewController *view = [LoginViewController new];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:view];

    [presentingViewController presentViewController:nav animated:YES completion:nil];
}

@end

