//
//  AdminPanelLogCell.h
//  MackNotas
//
//  Created by Caio Remedio on 06/12/15.
//  Copyright © 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdminPanelLogCell : UITableViewCell

- (void)loadWithLog:(NSMutableAttributedString *)log;
+ (CGFloat)height;

@end
