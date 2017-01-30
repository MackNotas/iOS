//
//  MNTabBarController.m
//  MackNotas
//
//  Created by Caio Remedio on 17/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MNTabBarController.h"

@interface MNTabBarController ()

@end

@implementation MNTabBarController

- (instancetype)init {

    self = [super init];

    if (self) {
        self.tabBar.tintColor = [UIColor vermelhoMainBackground];
        self.tabBar.backgroundColor = [UIColor whiteColor];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
