//
//  BlurView.h
//  MackNotas
//
//  Created by Caio Remedio on 21/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BlurViewDelegate <NSObject>

@required
- (void)blurViewDidTouchOnBackground;

@end

@interface BlurView : UIView

@property (nonatomic, assign) id<BlurViewDelegate> delegate;

@end
