//
//  HorarioCell.m
//  MackNotas
//
//  Created by Caio Remedio on 05/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "HorarioCell.h"

@implementation HorarioCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithMateria:(NSString *)materia andHora:(NSString *)hora {

    self.lblMateria.text = materia;
    self.lblHora.text = hora;
}

+ (CGFloat)cellHeight {

    return 44.0f;
}

@end
