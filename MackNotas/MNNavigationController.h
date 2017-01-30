//
//  MNNavigationController.h
//  MackNotas
//
//  Created by Caio Remedio on 19/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MNNavigationController : UINavigationController

- (void)showActivityIndicatorOnRight:(BOOL)shouldShow WithOldDefaultBtn:(UIBarButtonItem *)btn;

@end
