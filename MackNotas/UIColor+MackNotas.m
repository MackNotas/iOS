//
//  UIColor+MackNotas.m
//  MackNotas
//
//  Created by Caio Remedio on 19/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "UIColor+MackNotas.h"

@implementation UIColor (MackNotas)

+ (UIColor *)colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b andAlpha:(CGFloat)alpha {

    return [UIColor colorWithRed:((r) / 255.0f) green:((g) / 255.0f) blue:((b) / 255.0f) alpha:alpha];
}

+ (UIColor *)colorFromHex:(NSInteger)hex {
    return [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0 \
                           green:((float)((hex & 0x00FF00) >>  8))/255.0 \
                            blue:((float)((hex & 0x0000FF) >>  0))/255.0 \
                           alpha:1.0];
}


+ (UIColor *)vermelhoMainBackground {

    return [UIColor colorWithR:187.0f G:5.0f B:5.0f andAlpha:1.0f];
}

+ (UIColor *)cinzaBtnLoginDisable {

    return [UIColor colorWithR:205.0f G:205.0f B:205.0f andAlpha:1.0f];
}

+ (UIColor *)verdeFaltas {

    return [UIColor colorWithR:0.0f G:200.0f B:0.0f andAlpha:1.0f];
}

+ (UIColor *)blueGreen {

    return [UIColor colorWithR:34.0f G:139.0f B:34.0f andAlpha:1.0f];
}

+ (UIColor *)placeholder {

    return [UIColor colorWithWhite:0.8f
                             alpha:1.0f];
}

+ (UIColor *)infoColor {

    return [UIColor colorWithRed:0.0f
                           green:0.8f
                            blue:0.0f
                           alpha:1.0f];
}

+ (UIColor *)verboseColor {

    return [UIColor colorWithRed:0.0f
                           green:0.0f
                            blue:0.8f
                           alpha:1.0f];
}

+ (UIColor *)debugColor {

    return [UIColor colorWithRed:0.71f
                           green:0.37f
                            blue:0.02f
                           alpha:1.0f];
}

+ (UIColor *)warnColor {

    return [UIColor colorWithRed:0.5f
                           green:0.0f
                            blue:0.5f
                           alpha:1.0f];
}

@end
