//
//  AcCell.h
//  MackNotas
//
//  Created by Caio Remedio on 5/22/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNAc;
@interface AcCell : UITableViewCell

FOUNDATION_EXPORT NSString *kEmptyHours;

@property (strong, nonatomic) IBOutlet UILabel *lblTipoAtiv;
@property (strong, nonatomic) IBOutlet UILabel *lblDataAtiv;
@property (strong, nonatomic) IBOutlet UILabel *lblModalidadeAtiv;
@property (strong, nonatomic) IBOutlet UILabel *lblAnoSemAtiv;
@property (strong, nonatomic) IBOutlet UILabel *lblHorasAtiv;

- (void)loadWithAC:(MNAc *)ac;

@end
