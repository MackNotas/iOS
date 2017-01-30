//
//  FeedbackMenuView.m
//  MackNotas
//
//  Created by Caio Remedio on 20/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "FeedbackMenuView.h"

/**
 *  Frameworks
 */
#import <pop/POP.h>

@implementation FeedbackMenuView

- (instancetype)init {

    self = [super init];

    if (self) {
        NSArray *views = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([FeedbackMenuView class])
                                                       owner:self

                                                     options:nil];
        self = [views firstObject];
        self.layer.cornerRadius = 4.0f;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - Public Methods

- (void)animate {

    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.fromValue = [NSValue valueWithCGSize:CGSizeMake(1.3f, 1.3f)];
    scaleAnimation.toValue = [NSValue valueWithCGSize:CGSizeMake(1.0f, 1.0f)];
    scaleAnimation.springBounciness = 15.0f;

    [self.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
}

#pragma mark - Event Actions

- (IBAction)btnReportBugClick:(id)sender {

    if ([self.delegate respondsToSelector:@selector(feedbackMenuDidClickOnReportBug)]) {
        [self.delegate feedbackMenuDidClickOnReportBug];
    }
}

- (IBAction)btnSuggestionsClick:(id)sender {

    if ([self.delegate respondsToSelector:@selector(feedbackMenuDidClickOnSuggestion)]) {
        [self.delegate feedbackMenuDidClickOnSuggestion];
    }
}

- (IBAction)btnOtherClick:(id)sender {

    if ([self.delegate respondsToSelector:@selector(feedbackMenuDidClickOnOther)]) {
        [self.delegate feedbackMenuDidClickOnOther];
    }
}

- (IBAction)btnCloseViewClick:(id)sender {

    if ([self.delegate respondsToSelector:@selector(feedbackMenuDidClickOnCloseView)]) {
        [self.delegate feedbackMenuDidClickOnCloseView];
    }
}

@end
