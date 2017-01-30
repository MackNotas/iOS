//
//  MonthHeader.h
//  MackNotas
//
//  Created by Caio Remedio on 10/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MonthHeader : UITableViewHeaderFooterView

@property (strong, nonatomic) IBOutlet UILabel *lblMonth;
@property (strong, nonatomic, readonly) IBOutlet UIView *contentView;

@property (nonatomic) NSArray *arrayMeses;

- (void)loadWithMonthNumber:(NSInteger)month;
+ (CGFloat)viewHeight;

@end
