//
//  MonthHeader.m
//  MackNotas
//
//  Created by Caio Remedio on 10/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "MonthHeader.h"

@implementation MonthHeader

- (void)awakeFromNib {
    
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOpacity = 0.8f;
    self.layer.shadowRadius = 1.0f;
    self.layer.shadowOffset = CGSizeMake(CGFLOAT_MIN,
                                         CGFLOAT_MIN);
    self.contentView.backgroundColor = [UIColor blueGreen];
    self.arrayMeses = @[@"Janeiro",
                        @"Fevereiro",
                        @"Março",
                        @"Abril",
                        @"Maio",
                        @"Junho",
                        @"Julho",
                        @"Agosto",
                        @"Setembro",
                        @"Outubro",
                        @"Novembro",
                        @"Dezembro"];

}

- (void)loadWithMonthNumber:(NSInteger)month {

    self.lblMonth.text = self.arrayMeses[month];
}

+ (CGFloat)viewHeight {

    return 44.0f;
}

@end
