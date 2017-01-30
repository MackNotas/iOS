//
//  UIImage+Helper.m
//  MackNotas
//
//  Created by Caio Remedio on 21/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)

+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();

    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);

    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return image;
}

@end
