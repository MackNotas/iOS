//
//  CalendarItemCell.h
//  MackNotas
//
//  Created by Caio Remedio on 30/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNCalendario;

@interface CalendarItemCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *lblData;

@property (strong, nonatomic) IBOutlet UIView *viewMain;
@property (strong, nonatomic) IBOutlet UILabel *lblMateria;
@property (strong, nonatomic) IBOutlet UILabel *lblProva;

- (void)loadWithCalendario:(MNCalendario *)calendario;

+ (CGFloat)height;

@end
