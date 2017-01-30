//
//  FormCell.h
//  MackNotas
//
//  Created by Caio Remedio on 12/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) IBOutlet UITextField *txtFieldInput;

- (void)loadWithPlaceholderTitle:(NSString *)title;
- (void)loadWithPlaceholderTitle:(NSString *)title
                    keyboardType:(UIKeyboardType)keyboardType;
- (void)setTextFieldDelegate:(id)owner andTag:(NSInteger)tag andKeyboardType:(UIKeyboardType)keyboardType;

@end
