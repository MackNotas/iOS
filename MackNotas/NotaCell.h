//
//  NotaCell.h
//  MackNotas
//
//  Created by Caio Remedio on 01/05/16.
//  Copyright © 2016 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotaCell : UICollectionViewCell
- (void)load:(NSString *)nota
        tipo:(NSString *)tipo;
+ (CGSize)sizeForNota:(NSString *)nota
                 tipo:(NSString *)tipo;
@end
