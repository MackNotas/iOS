//
//  MNNavigationController.m
//  MackNotas
//
//  Created by Caio Remedio on 19/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNNavigationController.h"
#import "LoginViewController.h"

@interface MNNavigationController ()

@end

@implementation MNNavigationController

- (instancetype)initWithRootViewController:(UIViewController *)rootViewController {

    self = [super initWithRootViewController:rootViewController];

    if (self) {
        self.navigationBar.translucent = NO;
        self.navigationBar.opaque = YES;
        self.navigationBar.barTintColor = [UIColor vermelhoMainBackground];
        self.navigationBar.tintColor = [UIColor whiteColor];
        [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
        if ([rootViewController isKindOfClass:[LoginViewController class]]) {
            [self setNavigationBarHidden:YES animated:NO];
        }
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showActivityIndicatorOnRight:(BOOL)shouldShow WithOldDefaultBtn:(UIBarButtonItem *)refreshBarBtn {

    UIBarButtonItem *btn;

    if (shouldShow) {
        UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc]
                                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [actInd startAnimating];
        btn.enabled = NO;
        btn = [[UIBarButtonItem alloc] initWithCustomView:actInd];
    }
    else {
        btn = refreshBarBtn;
    }

    [UIView animateWithDuration:0.4f animations:^{
        self.navigationItem.rightBarButtonItem.customView.alpha = shouldShow ? 1.0f : 0.0f;
    } completion:^(BOOL finished) {
        self.navigationItem.rightBarButtonItem = btn;
    }];
}

@end
