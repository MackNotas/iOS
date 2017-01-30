//
//  EmNotasTableViewCell.h
//  MackNotas
//
//  Created by Caio Remedio on 22/08/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNFalta;
@class MNNota;

@interface EmNotasTableViewCell : UITableViewCell

- (void)loadWithNota:(MNNota *)nota;

+ (CGFloat)cellHeightWithNota:(MNNota *)nota;

@end
