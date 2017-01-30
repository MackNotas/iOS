//
//  NotasTableViewCell.h
//  MackNotas
//
//  Created by Caio Remedio on 19/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNFalta;
@class MNNota;

@interface NotasTableViewCell : UITableViewCell

- (void)loadWithNota:(MNNota *)nota;
+ (CGFloat)size;

@end
