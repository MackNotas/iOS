//
//  HorarioCell.h
//  MackNotas
//
//  Created by Caio Remedio on 05/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HorarioCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblHora;
@property (strong, nonatomic) IBOutlet UILabel *lblMateria;

- (void)loadWithMateria:(NSString *)materia andHora:(NSString *)hora;
+ (CGFloat)cellHeight;

@end
