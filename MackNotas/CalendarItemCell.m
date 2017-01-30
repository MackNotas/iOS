//
//  CalendarItemCell.m
//  MackNotas
//
//  Created by Caio Remedio on 30/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "CalendarItemCell.h"
#import "MNCalendario.h"

@implementation CalendarItemCell

- (void)awakeFromNib {
    self.lblMateria.text = @"Cobolzera";
    self.separatorInset = UIEdgeInsetsMake(0.0f,
                                           self.bounds.size.width,
                                           0.0f,
                                           0.0f);
    self.viewMain.layer.cornerRadius = 3.5f;
    self.viewMain.layer.shadowColor = [UIColor blackColor].CGColor;
    self.viewMain.layer.shadowOpacity = 0.5f;
    self.viewMain.layer.shadowRadius = 0.8f;
    self.viewMain.layer.shadowOffset = CGSizeMake(CGFLOAT_MIN,
                                                  CGFLOAT_MIN);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithCalendario:(MNCalendario *)calendario {

    self.lblMateria.text = calendario.materia;
    self.lblProva.text  = calendario.tipo;
    self.lblData.attributedText = [self dateAttributedStringWithDia:calendario.dia
                                                          diaSemana:calendario.diaSemana
                                                             andMes:calendario.mesNumero];

    CGFloat cellAlpha = [self hasPassedWithCalendario:calendario] ? 0.25f : 1.0f;

    self.contentView.alpha = cellAlpha;
}

- (NSAttributedString *)dateAttributedStringWithDia:(NSString *)dia
                                          diaSemana:(NSString *)diaSemana
                                             andMes:(NSString *)mes {

    /**
     *  Paragraphs
     */
    NSMutableParagraphStyle *styleDia = [NSMutableParagraphStyle new];
    styleDia.alignment = NSTextAlignmentCenter;

    NSMutableParagraphStyle *styleDiaSemana = [NSMutableParagraphStyle new];
    styleDiaSemana.alignment = NSTextAlignmentCenter;

    /**
     *  Text Attributed
     */
    NSMutableAttributedString *attrString = [NSMutableAttributedString new];

    BOOL isProvaToday = [GeneralHelper isTodayWithDay:dia
                                             andMonth:mes];
    BOOL isProvaTomorrow = [GeneralHelper isTomorrowWithDay:dia
                                                   andMonth:mes];

    UIColor *colorDate = isProvaToday || isProvaTomorrow ? [UIColor blueColor] : [UIColor blackColor];

    [attrString appendAttributedString:[[NSAttributedString alloc]
                                        initWithString:dia
                                        attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Light"
                                                                                           size:28.0f],
                                                     NSForegroundColorAttributeName : colorDate,
                                                     NSParagraphStyleAttributeName : styleDia
                                                     }]];

    [attrString appendAttributedString:[[NSAttributedString alloc]
                                        initWithString:@"\n"]];

    [attrString appendAttributedString:[[NSAttributedString alloc]
                                        initWithString:diaSemana
                                        attributes:@{NSFontAttributeName : [UIFont fontWithName:@"Helvetica Neue"
                                                                                           size:14.5f],
                                                     NSForegroundColorAttributeName : colorDate,
                                                     NSParagraphStyleAttributeName : styleDiaSemana
                                                     }]];
    return attrString;
}

- (BOOL)hasPassedWithCalendario:(MNCalendario *)calendario {

    NSInteger currentMonth = [GeneralHelper currentMonth];
    NSInteger currentDay = [GeneralHelper currentDay];

    if (calendario.mesNumero.integerValue < currentMonth) {
        return YES;
    }
    else if (calendario.mesNumero.integerValue == currentMonth &&
             calendario.dia.integerValue < currentDay) {
        return YES;
    }
    return NO;
}

+ (CGFloat)height {

    return 80.0f;
}

@end
