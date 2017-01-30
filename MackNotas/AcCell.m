//
//  AcCell.m
//  MackNotas
//
//  Created by Caio Remedio on 5/22/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "AcCell.h"
#import "MNAc.h"

@implementation AcCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithAC:(MNAc *)ac {

    if (ac) {
        self.lblTipoAtiv.text       =   ac.tipo_ativ;
        self.lblDataAtiv.text       =   ac.data;
        self.lblModalidadeAtiv.text =   ac.modalidade;
        self.lblAnoSemAtiv.text     =   ac.anoSemestre;
        self.lblHorasAtiv.text      =   ac.horas;
    }
}

@end
