//
//  NotasTableViewCell.m
//  MackNotas
//
//  Created by Caio Remedio on 19/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "NotasTableViewCell.h"
#import "MNFalta.h"
#import "MNNota.h"
#import "NotaCell.h"

const CGFloat kDefaultFaltaSize = 18.0f;
static CGFloat const size = 234.0f;

@interface NotasTableViewCell () <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

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
//@property (nonatomic) NSArray *arrayLblValorNota;
//@property (nonatomic) NSArray *arrayLblTipoNota;
@property (nonatomic) NSArray *arrayLetras;
@property (nonatomic) NSDictionary *notas;
@property (nonatomic) NSArray *arrayAvailableNotas;

/**
 *  Constraints
 */
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrViewFaltasTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrViewFaltasY;
//@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrLblFaltaErrorTop;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *cstrLblFaltaErrorY;

@end

@implementation NotasTableViewCell

#pragma mark - View

- (void)awakeFromNib {

    [self.collectionView registerNib:[UINib
                                      nibWithNibName:NSStringFromClass([NotaCell class])
                                      bundle:nil]
          forCellWithReuseIdentifier:NSStringFromClass([NotaCell class])];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Public Methods

+ (CGFloat)size {
    return size;
}

- (void)loadWithNota:(MNNota *)nota {

    self.notas = nota.notas;
    self.arrayAvailableNotas = [self.notas.allKeys
                                sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) { return obj1 > obj2; }];
    MNFalta *falta = nota.falta;

    [self.collectionView reloadData];

    /**
     *  Faltas
     */

    self.lblFaltaError.hidden = falta.isValid;
    self.separatorFaltas.hidden = !falta.isValid;
    self.viewFaltas.hidden = !falta.isValid;

    if (falta.isValid) {
        self.lblFaltaTexto.attributedText = [self faltaTextoWithFalta:falta];
        self.lblUltimaFaltaTexto.text = [self ultimaFaltaTextoWithString:falta.ultimaFalta];
    }
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
        fontAttribute = [UIFont systemFontOfSize:kDefaultFaltaSize
                                         weight:UIFontWeightBold];
    }
    else {
        fontAttribute = [UIFont fontWithName:@"HelveticaNeue-Bold"
                                        size:kDefaultFaltaSize];
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

#pragma mark - UICollectionView Data Source

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    NotaCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([NotaCell class])
                                                               forIndexPath:indexPath];

    NSString *notaTipo = self.arrayAvailableNotas[indexPath.row];
    NSString *nota = self.notas[notaTipo];
    [cell load:nota tipo:notaTipo];

    return cell;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return self.notas.count;
}

#pragma mark - UICollectionView Delegate

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    NSString *notaTipo = self.arrayAvailableNotas[indexPath.row];
    NSString *nota = self.notas[notaTipo];

    return [NotaCell sizeForNota:nota
                            tipo:notaTipo];
}

@end
