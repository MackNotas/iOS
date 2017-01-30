//
//  UIView+MackNotas.m
//  MackNotas
//
//  Created by Caio Remedio on 06/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "UIView+MackNotas.h"

@implementation UIView (MackNotas)

- (void)addSubviewAndFillWithContent:(UIView *)contentView {

    if (!contentView) {
        return;
    }

    [self addSubview:contentView];

    contentView.translatesAutoresizingMaskIntoConstraints = NO;

    [self addConstraint: [NSLayoutConstraint constraintWithItem:contentView
                                                      attribute:NSLayoutAttributeWidth
                                                      relatedBy:NSLayoutRelationEqual
                                                         toItem:self
                                                      attribute:NSLayoutAttributeWidth
                                                     multiplier:1.0f
                                                       constant:0.0f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                     attribute:NSLayoutAttributeHeight
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeHeight
                                                    multiplier:1.0f
                                                      constant:0.0f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                     attribute:NSLayoutAttributeLeft
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeLeft
                                                    multiplier:1.0f
                                                      constant:0.0f]];

    [self addConstraint:[NSLayoutConstraint constraintWithItem:contentView
                                                     attribute:NSLayoutAttributeTop
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:self
                                                     attribute:NSLayoutAttributeTop
                                                    multiplier:1.0f
                                                      constant:0.0f]];
}

- (void)addSubviewAndFillAnimated:(UIView *)contentView {

    contentView.alpha = 0.0f;
    [self addSubviewAndFillWithContent:contentView];

    [UIView animateWithDuration:0.3f animations:^{
        contentView.alpha = 1.0f;
    }];
}

- (void)addSubviewAndFillAnimated:(UIView *)contentView
                     withMaxAlpha:(CGFloat)alpha {

    contentView.alpha = 0.0f;
    [self addSubviewAndFillWithContent:contentView];

    [UIView animateWithDuration:0.3f animations:^{
        contentView.alpha = alpha;
    }];
}

- (void)addSubviewAnimated:(UIView *)contentView {

    contentView.alpha = 0.0f;
    [self addSubview:contentView];

    [UIView animateWithDuration:0.3f animations:^{
        contentView.alpha = 1.0f;
    }];
}

- (void)removeFromSuperViewAnimatedCompletion:(void (^)(BOOL finished))completion {

    [UIView animateWithDuration:0.4f animations:^{
        self.alpha = 0.0f;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
            dispatch_async(dispatch_get_main_queue(), ^{
                completion(finished);
            });
        }
    }];
}

@end
