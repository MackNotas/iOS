//
//  BlurView.m
//  MackNotas
//
//  Created by Caio Remedio on 21/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "BlurView.h"
#import "UIView+MackNotas.h"
#import "UIImage+Helper.h"

@implementation BlurView

- (instancetype)init {

    self = [super initWithFrame:CGRectZero];

    if (self) {
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
            UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
            UIVisualEffectView *viewVisualEffect = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
            [self addSubviewAndFillWithContent:viewVisualEffect];
        }
        else {
            self.backgroundColor = [UIColor clearColor];
            self.backgroundColor = [UIColor colorWithR:8
                                                     G:8
                                                     B:8
                                              andAlpha:0.7f];
        }

        UITapGestureRecognizer *gestRecog = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTouchOnBackground)];
        gestRecog.numberOfTapsRequired = 1;
        [self addGestureRecognizer:gestRecog];
    }
    return self;
}

#pragma mark - Private Methods

- (void)didTouchOnBackground {

    if ([self.delegate respondsToSelector:@selector(blurViewDidTouchOnBackground)]) {
        [self.delegate blurViewDidTouchOnBackground];
    }
}

@end
