//
//  MessageCell.h
//  MackNotas
//
//  Created by Caio Remedio on 22/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageCell : UITableViewCell

+ (CGFloat)height;
- (void)loadWithPlaceholder:(NSString *)placeholder;
- (void)setTextViewDelegate:(id)owner;

@end
