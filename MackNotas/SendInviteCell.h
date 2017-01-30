//
//  SendInviteCell.h
//  MackNotas
//
//  Created by Caio Remedio on 12/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SendInviteCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

- (void)loadWithTitle:(NSString *)title;
- (void)enableCell:(BOOL)shouldEnable;

@end
