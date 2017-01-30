//
//  SendInviteCell.m
//  MackNotas
//
//  Created by Caio Remedio on 12/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "SendInviteCell.h"

CGFloat static kMinimumAlpha = 0.3f;
CGFloat static kMaximumAlpha = 1.0f;

@implementation SendInviteCell

- (void)awakeFromNib {
    self.contentView.backgroundColor = [UIColor vermelhoMainBackground];
    self.contentView.alpha = kMinimumAlpha;
    self.userInteractionEnabled = NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    [self enableCell:NO];
}

- (void)loadWithTitle:(NSString *)title {

    self.lblTitle.text = title;
}

- (void)enableCell:(BOOL)shouldEnable {

    CGFloat alphaValue = shouldEnable ? kMaximumAlpha : kMinimumAlpha;

    [UIView animateWithDuration:0.4f animations:^{
        self.contentView.alpha = alphaValue;
    } completion:^(BOOL finished) {
        if (finished) {
            self.userInteractionEnabled = shouldEnable;
        }
    }];
}

@end
