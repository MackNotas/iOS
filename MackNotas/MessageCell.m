//
//  MessageCell.m
//  MackNotas
//
//  Created by Caio Remedio on 22/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MessageCell.h"

@interface MessageCell ()

@property (strong, nonatomic) IBOutlet UITextView *viewText;

@end

@implementation MessageCell

- (void)awakeFromNib {

    self.viewText.textColor = [UIColor placeholder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

+ (CGFloat)height {

    return 110.0f;
}

- (void)loadWithPlaceholder:(NSString *)placeholder {

    self.viewText.text = placeholder;
    self.viewText.textColor = [UIColor placeholder];
}

- (void)setTextViewDelegate:(id)owner {

    self.viewText.delegate = owner;
}

@end
