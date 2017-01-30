//
//  GAHelper.m
//  MackNotas
//
//  Created by Caio Remedio on 03/08/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "GAHelper.h"
#import <Google/Analytics.h>

@implementation GAHelper

+ (void)trackViewWithName:(NSString *)viewName {

    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:viewName];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
}

@end
