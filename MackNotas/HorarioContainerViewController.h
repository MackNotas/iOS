
//
//  HorarioContainerViewController.h
//  MackNotas
//
//  Created by Caio Remedio on 02/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorarioGenericViewController.h"

@interface HorarioContainerViewController : UIViewController
<UIPageViewControllerDataSource, UIPageViewControllerDelegate, HorarioGenericViewDelegate>

@end
