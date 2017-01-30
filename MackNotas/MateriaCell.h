//
//  MateriaCell.h
//  MackNotas
//
//  Created by Caio Remedio on 18/05/16.
//  Copyright © 2016 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MNNota;

@interface MateriaCell : UITableViewCell

+ (CGFloat)sizeForNota:(MNNota *)nota;
- (void)load:(MNNota *)nota;

@end
