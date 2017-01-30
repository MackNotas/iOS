//
//  FormCell.m
//  MackNotas
//
//  Created by Caio Remedio on 12/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "FormCell.h"

@implementation FormCell

- (void)awakeFromNib {

    self.txtFieldInput.delegate = self;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

#pragma mark - Public Methods

- (void)loadWithPlaceholderTitle:(NSString *)title keyboardType:(UIKeyboardType)keyboardType {

    self.txtFieldInput.placeholder = title;
    self.txtFieldInput.keyboardType = keyboardType;
}

- (void)loadWithPlaceholderTitle:(NSString *)title {

    [self loadWithPlaceholderTitle:title
                      keyboardType:UIKeyboardTypeAlphabet];
}

- (void)setTextFieldDelegate:(id)owner andTag:(NSInteger)tag andKeyboardType:(UIKeyboardType)keyboardType {

    self.txtFieldInput.delegate = owner;
    self.txtFieldInput.tag = tag;
    self.txtFieldInput.keyboardType = keyboardType;
}

@end
