//
//  EmNotasTableViewCell.m
//  MackNotas
//
//  Created by Caio Remedio on 22/08/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "EmNotasTableViewCell.h"
#import "MNFalta.h"
#import "MNNota.h"

const CGFloat kDefaultFaltaSize2 = 18.0f;

@interface EmNotasTableViewCell ()

/**
 *  Labels Valor da Nota
 */
@property (strong, nonatomic) IBOutlet UILabel *lblValorA;
@property (strong, nonatomic) IBOutlet UILabel *lblValorB;
@property (strong, nonatomic) IBOutlet UILabel *lblValorC;
@property (strong, nonatomic) IBOutlet UILabel *lblValorD;
@property (strong, nonatomic) IBOutlet UILabel *lblValorE;
@property (strong, nonatomic) IBOutlet UILabel *lblValorF;
@property (strong, nonatomic) IBOutlet UILabel *lblValorG;
@property (strong, nonatomic) IBOutlet UILabel *lblValorH;
@property (strong, nonatomic) IBOutlet UILabel *lblValorI;
@property (strong, nonatomic) IBOutlet UILabel *lblValorJ;

@property (strong, nonatomic) IBOutlet UILabel *lblValorBonif;
@property (strong, nonatomic) IBOutlet UILabel *lblValorMP;

/**
 *  Labels Descricao da Nota
 */
@property (strong, nonatomic) IBOutlet UILabel *lblTipoA;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoB;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoC;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoD;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoE;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoF;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoG;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoH;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoI;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoJ;

@property (strong, nonatomic) IBOutlet UILabel *lblTipoBonif;
@property (strong, nonatomic) IBOutlet UILabel *lblTipoMP;

/**
 *  ViewFaltas
 */
@property (strong, nonatomic) IBOutlet UIView *viewFaltas;
@property (strong, nonatomic) IBOutlet UIView *separatorFaltas;

@property (strong, nonatomic) IBOutlet UILabel *lblFaltaTexto;
@property (strong, nonatomic) IBOutlet UILabel *lblUltimaFaltaTexto;
@property (strong, nonatomic) IBOutlet UILabel *lblFaltaError;

/**
 *  Arrays
 */
@property (nonatomic) NSArray *arrayLblValorNota;
@property (nonatomic) NSArray *arrayLblTipoNota;
@property (nonatomic) NSArray *arrayLetras;

/**
 *  Constraints
 */
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrViewFaltasTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrViewFaltasY;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrLblFaltaErrorTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrLblFaltaErrorY;

@end

@implementation EmNotasTableViewCell

#pragma mark - View

- (void)awakeFromNib {

    self.arrayLblTipoNota = @[self.lblTipoA,
                              self.lblTipoB,
                              self.lblTipoC,
                              self.lblTipoD,
                              self.lblTipoE,
                              self.lblTipoF,
                              self.lblTipoG,
                              self.lblTipoH,
                              self.lblTipoI,
                              self.lblTipoJ,
                              self.lblTipoBonif,
                              self.lblTipoMP];

    self.arrayLblValorNota  = @[self.lblValorA,
                                self.lblValorB,
                                self.lblValorC,
                                self.lblValorD,
                                self.lblValorE,
                                self.lblValorF,
                                self.lblValorG,
                                self.lblValorH,
                                self.lblValorI,
                                self.lblValorJ,
                                self.lblValorBonif,
                                self.lblValorMP];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

- (void)loadWithNota:(MNNota *)nota {

    NSUInteger fixedLbl = 0;
    NSUInteger  const distanceBetweenLabels = 8;
    CGFloat     const lblValorHeight = 21.0f;

    NSArray *notas = nota.notas;
    MNFalta *falta = nota.falta;

    /**
     *  Notas
     */
    for (int i = 0; i < self.arrayLblValorNota.count; i++) {
        NSString *notaString = notas[i];
        if (![notaString isEqualToString:@""] && i < 10) {
            UILabel *lblValorNota = self.arrayLblValorNota[fixedLbl++];
            UILabel *lblTipoNota = self.arrayLblTipoNota[fixedLbl-1];

            lblValorNota.text = notaString;
            lblValorNota.hidden = NO;

            lblTipoNota.hidden = NO;
            lblTipoNota.text = self.arrayLetras[i];

        }
        else if (i >= 10) {
            UILabel *lblValorNota = self.arrayLblValorNota[i];
            UILabel *lblTipoNota = self.arrayLblTipoNota[i];

            if (![notaString isEqualToString:@""]) {
                lblValorNota.text = notaString;
                lblValorNota.hidden = NO;

                lblTipoNota.hidden = NO;
            }
            else {
                lblValorNota.hidden = YES;
            }
        }
    }

    for (int i = (int)fixedLbl; i < 10; i++) {
        UILabel *lblValorNota = self.arrayLblValorNota[i];
        lblValorNota.hidden = YES;

        UILabel *lblTipoNota = self.arrayLblTipoNota[i];
        lblTipoNota.hidden = YES;
    }

    /**
     *  Faltas
     */

    self.lblFaltaError.hidden = falta.isValid;
    self.viewFaltas.hidden = !falta.isValid;

    if (falta) {

        CGFloat const topDistance   = 150.0f;
        CGFloat const YPosition     = -75.0f;

        CGFloat const topFormula    = topDistance + ((fixedLbl - 5) * (distanceBetweenLabels + lblValorHeight));
        CGFloat const YFormula      = YPosition - ((fixedLbl - 5) * (distanceBetweenLabels + lblValorHeight))/2;

        if (falta.isValid) {
            self.separatorFaltas.hidden = NO;
            self.lblFaltaTexto.attributedText = [self faltaTextoWithFalta:falta];
            self.lblUltimaFaltaTexto.text = [self ultimaFaltaTextoWithString:falta.ultimaFalta];

            if (fixedLbl <= 5) {
                self.cstrViewFaltasTop.constant = topDistance;
                self.cstrViewFaltasY.constant = YPosition;
            }
            else {
                self.cstrViewFaltasTop.constant = topFormula;
                self.cstrViewFaltasY.constant = YFormula;
            }
        }
        else {
            if (fixedLbl <= 5) {
                self.cstrLblFaltaErrorTop.constant = topDistance;
                self.cstrLblFaltaErrorY.constant = YPosition;
            }
            else {
                self.cstrLblFaltaErrorTop.constant = topFormula;
                self.cstrLblFaltaErrorY.constant = YFormula;
            }
        }
    }
}

+ (CGFloat)cellHeightWithNota:(MNNota *)nota {

    NSUInteger numberOfVisibleItems = 0;
    NSUInteger distanceBetweenLabels = 8;
    NSUInteger numberOfFixedItems = 5;
    CGFloat lblValorHeight = 21.0f;
    CGFloat marginBotton = 8.0f;
    CGFloat viewFaltasHeight = 50.0f;
    CGFloat viewFaltasMargins = 14.0f;

    NSArray *notas = nota.notas;

    NSUInteger aux = 0;
    for (int i = 0; i < 10; i++) {
        NSString *notaString = notas[i];
        if (![notaString isEqualToString:@""]) {
            aux++;
        }
    }

    numberOfVisibleItems = (aux >= 6) ? aux - 5 : 0;
    //    hasFaltas = NO;
    if (nota.hasFalta) {
        return (lblValorHeight + distanceBetweenLabels) * (numberOfFixedItems + numberOfVisibleItems)
        + marginBotton + (viewFaltasHeight + viewFaltasMargins);
    }

    return (lblValorHeight + distanceBetweenLabels) * (numberOfFixedItems + numberOfVisibleItems)
    + marginBotton;
}

#pragma mark - Private Methods

- (NSAttributedString *)faltaTextoWithFalta:(MNFalta *)falta {

    NSMutableAttributedString *attFaltaText = [NSMutableAttributedString new];
    NSMutableAttributedString *attPorcentagem;

    CGFloat porcentagemFalta;

    if (falta.porcentagem) {
        porcentagemFalta = falta.porcentagem.floatValue;
        attPorcentagem = [[NSMutableAttributedString alloc]
                          initWithString:fstr(@"(%@%%)", falta.porcentagem)];
    }
    else {
        return [[NSAttributedString alloc] initWithString:@"Erro ao obter as faltas!"];
    }

    [attFaltaText appendAttributedString:[[NSAttributedString alloc]
                                          initWithString:fstr(@"%@", falta.faltas)
                                          attributes:[self attributesForFaltas:porcentagemFalta]]];

    [attPorcentagem addAttributes:[self attributesForFaltas:porcentagemFalta]
                            range:NSMakeRange(0, falta.porcentagem.length+3)];

    [attFaltaText appendAttributedString:[[NSAttributedString alloc]
                                          initWithString:fstr(@" de %@ faltas permitidas ", falta.permitido)
                                          ]];
    [attFaltaText appendAttributedString:attPorcentagem];

    return attFaltaText;
}

- (NSDictionary *)attributesForFaltas:(CGFloat)porcentagemFalta {

    UIFont *fontAttribute;

    if ([self respondsToSelector:@selector(systemFontOfSize:weight:)]) {
        fontAttribute = [UIFont systemFontOfSize:kDefaultFaltaSize2
                                          weight:UIFontWeightBold];
    }
    else {
        fontAttribute = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                        size:kDefaultFaltaSize2];
    }

    if (porcentagemFalta <= 15) {
        return @{NSForegroundColorAttributeName : [UIColor verdeFaltas],
                 NSFontAttributeName: fontAttribute};
    }
    else if (porcentagemFalta > 15 && porcentagemFalta <= 24) {
        return @{NSForegroundColorAttributeName : [UIColor orangeColor],
                 NSFontAttributeName: fontAttribute};
    }
    else if (porcentagemFalta >= 25) {
        return @{NSForegroundColorAttributeName : [UIColor redColor],
                 NSFontAttributeName: fontAttribute};
    }

    return @{};
}

- (NSString *)ultimaFaltaTextoWithString:(NSString *)stringData {

    if ([stringData isEqualToString:@"00/00/0000"]) {
        return @"Nunca";
    }
    return stringData;
}

#pragma mark - Properties Override

- (NSArray *)arrayLetras {
    
    if (_arrayLetras) {
        return _arrayLetras;
    }
    
    _arrayLetras = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J"];
    
    return _arrayLetras;
}

@end

