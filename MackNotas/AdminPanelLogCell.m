//
//  AdminPanelLogCell.m
//  MackNotas
//
//  Created by Caio Remedio on 06/12/15.
//  Copyright © 2015 Caio Remedio. All rights reserved.
//

#import "AdminPanelLogCell.h"

@interface AdminPanelLogCell()

@property (strong, nonatomic) IBOutlet UITextView *txtViewLogs;

@end

@implementation AdminPanelLogCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithLog:(NSMutableAttributedString *)log {

    self.txtViewLogs.attributedText = log;
}

+ (CGFloat)height {
    return 250.0f;
}

@end
