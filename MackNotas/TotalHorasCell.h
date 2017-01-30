//
//  TotalHorasCell.h
//  MackNotas
//
//  Created by Caio Remedio on 24/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNAc;

typedef NS_ENUM(NSInteger, AcTotalRows) {
    AcTotalRowsEnsino = 0,
    AcTotalRowsPesquisa,
    AcTotalRowsExcedentes,
    AcTotalRowsExtensao,
    AcTotalRowsTotal,
    AcTotalRowsCount
};

@interface TotalHorasCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTipo;
@property (strong, nonatomic) IBOutlet UILabel *lblHoras;

@property (nonatomic) NSArray *arrayTipos;

- (void)loadWithAc:(MNAc *)ac andRow:(NSInteger)row;

@end
