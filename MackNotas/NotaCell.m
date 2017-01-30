//
//  NotaCell.m
//  MackNotas
//
//  Created by Caio Remedio on 01/05/16.
//  Copyright © 2016 Caio Remedio. All rights reserved.
//

#import "NotaCell.h"

static CGFloat const leftMargin = 8.0f;
static CGFloat const distanceBetweenLbls = 10.0f;
static CGFloat const cellHeight = 30.0f;

@interface NotaCell()

@property (strong, nonatomic) IBOutlet UILabel *lblTipo;
@property (strong, nonatomic) IBOutlet UILabel *lblNota;

@end

@implementation NotaCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)load:(NSString *)nota tipo:(NSString *)tipo {
    self.lblNota.text = nota;
    self.lblTipo.text = tipo;
}

+ (CGSize)sizeForNota:(NSString *)nota tipo:(NSString *)tipo {

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]};

    CGSize sizeTipo = [tipo sizeWithAttributes:attributes];

    CGSize sizeNota = [nota sizeWithAttributes:attributes];

    CGFloat tipoWidth = ceilf(sizeTipo.width);
    CGFloat notaWidth = ceilf(sizeNota.width);

    return CGSizeMake(leftMargin +
                      tipoWidth +
                      distanceBetweenLbls +
                      notaWidth,
                      cellHeight);
}

@end
