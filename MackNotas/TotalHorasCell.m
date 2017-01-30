//
//  TotalHorasCell.m
//  MackNotas
//
//  Created by Caio Remedio on 24/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "TotalHorasCell.h"
#import "MNAc.h"

NSString * const kEmptyHours = @"0:00";

@implementation TotalHorasCell

- (void)awakeFromNib {

    self.arrayTipos = @[@"Ativ. de Ensino",
                        @"Ativ. de Pesquisa",
                        @"Ativ. de Extensão",
                        @"Excedentes",
                        @"Total de Horas"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)loadWithAc:(MNAc *)ac andRow:(NSInteger)row {

    self.lblTipo.text   = self.arrayTipos[row];
    self.lblHoras.text  = [self getTotalHorasWithAc:ac
                                             andRow:row];
}

#pragma mark - Private Methods

- (NSString *)getTotalHorasWithAc:(MNAc *)ac andRow:(NSInteger)row {

    if (row == AcTotalRowsEnsino) {
        return ac.atEnsino ?: kEmptyHours;
    }
    else if (row == AcTotalRowsPesquisa) {
        return ac.atPesquisa ?: kEmptyHours;
    }
    else if (row == AcTotalRowsExcedentes) {
        return ac.excedentes ?: kEmptyHours;
    }
    else if (row == AcTotalRowsExtensao) {
        return ac.atExtensao ?: kEmptyHours;
    }
    else if (row == AcTotalRowsTotal) {
        return ac.total ?: kEmptyHours;
    }

    return kEmptyHours;
}

@end
