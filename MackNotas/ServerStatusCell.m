//
//  ServerStatusCell.m
//  MackNotas
//
//  Created by Caio Remedio on 01/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "ServerStatusCell.h"

@implementation ServerStatusCell

- (void)awakeFromNib {
    self.lblServiceName.text = @"TIA Mackenzie";
    self.imgViewStatus.layer.cornerRadius = self.imgViewStatus.frame.size.height/2;
    self.imgViewStatus.layer.masksToBounds = YES;
    self.imgViewStatus.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.arrayLblTitle = @[@"TIA Mackenzie",
                           @"MackNotas",
                           @"MackNotas Push"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithServerStatus:(BOOL)isOnline andTitleForRow:(NSUInteger)row hasReloaded:(BOOL)hasReloaded {

    if (isOnline) {
        self.imgViewStatus.backgroundColor = [UIColor greenColor];
    }
    else {
        self.imgViewStatus.backgroundColor = [UIColor redColor];
    }
    if (hasReloaded) {
        [UIView animateWithDuration:0.6f animations:^{
            self.imgViewStatus.alpha = 1.0f;
            self.acLoading.alpha = 0.0f;
        } completion:^(BOOL finished) {
            [self.acLoading stopAnimating];
        }];
    }

    self.lblServiceName.text = self.arrayLblTitle[row];
}

@end
