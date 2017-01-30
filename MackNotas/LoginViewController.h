//
//  LoginViewController.h
//  Mack Notas
//
//  Created by Caio Remedio on 12/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LocalUser.h"

@class ParseErrorHandlingController;

@interface LoginViewController : UIViewController <UITextFieldDelegate>

- (IBAction)btnLoginClick:(id)sender;

@end
