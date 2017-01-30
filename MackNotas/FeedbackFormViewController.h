//
//  FeedbackFormViewController.h
//  MackNotas
//
//  Created by Caio Remedio on 21/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackFormViewController : UITableViewController <UITextViewDelegate, UITextFieldDelegate>

typedef NS_ENUM(NSInteger, FeedbackType) {
    FeedbackTypeProblem = 0,
    FeedbackTypeSuggestion,
    FeedbackTypeOther
};

- (instancetype)initWithType:(FeedbackType)type;

@end
