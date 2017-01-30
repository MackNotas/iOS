//
//  FeedbackMenuView.h
//  MackNotas
//
//  Created by Caio Remedio on 20/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FeedbackMenuDelegate <NSObject>

@required
- (void)feedbackMenuDidClickOnReportBug;
- (void)feedbackMenuDidClickOnSuggestion;
- (void)feedbackMenuDidClickOnOther;
- (void)feedbackMenuDidClickOnCloseView;

@end

//======================================================================================================================

@interface FeedbackMenuView : UIView

@property (nonatomic, assign) id<FeedbackMenuDelegate> delegate;

- (void)animate;

@end
