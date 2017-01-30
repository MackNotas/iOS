//
//  UIColor+MackNotas.h
//  MackNotas
//
//  Created by Caio Remedio on 19/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (MackNotas)

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b andAlpha:(CGFloat)alpha;
+ (UIColor *)colorFromHex:(NSInteger)hex;
+ (UIColor *)vermelhoMainBackground;
+ (UIColor *)cinzaBtnLoginDisable;
+ (UIColor *)verdeFaltas;
+ (UIColor *)blueGreen;
+ (UIColor *)placeholder;
+ (UIColor *)infoColor;
+ (UIColor *)verboseColor;
+ (UIColor *)debugColor;
+ (UIColor *)warnColor;
@end
