//
//  UIView+MackNotas.h
//  MackNotas
//
//  Created by Caio Remedio on 06/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MackNotas)

/**
 *  Add some UIView and fill the size to the entire screen with Constraints
 *
 *  @param contentView UIView to be filled on screen
 */
- (void)addSubviewAndFillWithContent:(UIView *)contentView;

/**
 *  Add some UIView, fill the size to the entire screen with fade animation
 *
 *  @param contentView UIView to be filled and animated on screen
 */
- (void)addSubviewAndFillAnimated:(UIView *)contentView;

/**
 *  Add some UIView and animate with fade animation
 *
 *  @param contentView UIView to be added and animated
 */
- (void)addSubviewAnimated:(UIView *)contentView;

/**
 *  Remove some UIView from superView but with some fade animation and returns if has been removed
 *
 *  @param completion UIView to be removed with some fade animation
 */
- (void)removeFromSuperViewAnimatedCompletion:(void (^)(BOOL finished))completion;

/**
 *  Add some UIView, fill the size to the entire superView with fade animation, with maximum given Alpha
 *
 *  @param contentView UIView to be filled and animated
 *  @param alpha       The maximum desired background's alpha
 */
- (void)addSubviewAndFillAnimated:(UIView *)contentView
                     withMaxAlpha:(CGFloat)alpha;

@end
