//
//  MateriaCell.m
//  MackNotas
//
//  Created by Caio Remedio on 18/05/16.
//  Copyright © 2016 Caio Remedio. All rights reserved.
//

#import "MateriaCell.h"
#import "MNNota.h"

typedef enum : NSInteger {
    colorTypeApproved = 0x3BB3E2,
    colorTypeUnapproved = 0xFF8595,
    colorTypeNI = 0x00A2CC,
} colorNota;

@interface MateriaCell()

@property (strong, nonatomic) IBOutlet UILabel *lblMateria;
@property (strong, nonatomic) IBOutlet UILabel *lblNotaN1;
@property (strong, nonatomic) IBOutlet UILabel *lblNotaN2;
@property (strong, nonatomic) IBOutlet UILabel *lblNotaMI;

@property (strong, nonatomic) IBOutlet UIImageView *imgViewN2;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewN1;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewMI;

@property (nonatomic) UIImage *imgApproved;
@property (nonatomic) UIImage *imgUnapproved;

@end

@implementation MateriaCell

- (void)awakeFromNib {
    [super awakeFromNib];

    self.imgApproved = [UIImage imageNamed:@"btn_bg_009edc_5"];
    self.imgUnapproved = [UIImage imageNamed:@"btn_bg_ee6161_5"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


- (void)load:(MNNota *)nota {

    self.lblMateria.text = nota.materia;

    NSDictionary *notas = nota.notas;

    self.lblNotaN1.text = fstr(@"%.1f", notas[@"NI 1"] ? [notas[@"NI 1"] floatValue] : 0.0f);
    self.lblNotaN2.text = fstr(@"%.1f", notas[@"NI 2"] ? [notas[@"NI 2"] floatValue] : 0.0f);

    NSString *miNota = @"0.0";
    id value;
    CGFloat notaValue;
    UIImage *imgMI;

    //
    //  Obtém o valor da última badge, que pode ser MI ou MF (caso exista PF)
    //      No webservice do TIA mobile a MF e MI pode vir `99.9`, usaremos como 0 em vez disso.
    //

    if ((value = notas[@"MF"]) && ![value isEqualToString:@"99.9"]) {
        notaValue = [value floatValue];
        miNota = fstr(@"%.1f", notaValue);
        imgMI = notaValue >= 6.0f ? self.imgApproved : self.imgUnapproved;
    }
    else if ((value = notas[@"MI"]) && ![value isEqualToString:@"99.9"]) {
        notaValue = [value floatValue];
        miNota = fstr(@"%.1f", notaValue);
        NSString *pfValue = notas[@"PF"];

        //
        //  O mackenzie faz calculos burros. A MI deveria ser N1+N2, mas ela é alterada caso tenha a PF. E como a
        //      PF vem NULL, então é usado a MI como media final. Enfim, se TEM PF então o usuario pode ter passado na materia
        //      tendo a nota >= 6, e não 7.5
        //

        if (pfValue &&
            ![pfValue isEqualToString:@""] &&
            ![pfValue isEqualToString:@"0.0"]) {
            imgMI = notaValue >= 6.0f ? self.imgApproved : self.imgUnapproved;
        }
        else {
            imgMI = notaValue >= 7.5f ? self.imgApproved : self.imgUnapproved;
        }
    }
    else {
        imgMI = self.imgUnapproved;
    }

    self.imgViewMI.image = imgMI;

    self.lblNotaMI.text = miNota;
}

+ (CGFloat)sizeForNota:(MNNota *)nota {

    NSDictionary *attributes = @{NSFontAttributeName: [UIFont systemFontOfSize:17.0f]};

    CGFloat const labelWidth = ((SCREEN_IS_4_7_INCHES) || (SCREEN_IS_5_5_INCHES)) ? 250.0f : 195.0f;

    CGRect sizeMateria = [nota.materia boundingRectWithSize:CGSizeMake(labelWidth, CGFLOAT_MAX)
                                                    options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:attributes
                                                    context:nil];

    CGFloat const verticalMargins = 11 + 11;
    CGFloat materiaHeight = ceilf(sizeMateria.size.height);

    return materiaHeight + verticalMargins;
}

@end
