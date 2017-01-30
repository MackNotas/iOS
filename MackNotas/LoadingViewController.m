//
//  LoadingViewController.m
//  LoadingTeste
//
//  Created by Caio Remedio on 06/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "LoadingViewController.h"
#import "UIView+MackNotas.h"
#import "BlurView.h"

@interface LoadingViewController ()
@property (strong, nonatomic) IBOutlet UIView *viewHUD;
@property (strong, nonatomic) IBOutlet UILabel *lblLoading;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *actIndicator;
@property (nonatomic) BlurView *viewBlur;

@property (nonatomic) NSString *customTitle;

@property (nonatomic) LoadingType loadingType;

@end

@implementation LoadingViewController

- (instancetype)initWithLoadingType:(LoadingType)loadingType {

    self = [super initWithNibName:NSStringFromClass(self.class)
                           bundle:nil];
    if (self) {
        _loadingType    = loadingType;
        _viewBlur       = [BlurView new];
    }
    return self;
}

- (instancetype)initWithCustomTitle:(NSString *)customTitle {

    self = [self initWithLoadingType:LoadingTypeCustom];

    if (self) {
        _customTitle = customTitle;
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViewHUD];
    [self setupBlurView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Private Methods

- (void)setupViewHUD {

    self.viewHUD.layer.cornerRadius = 8.0f;
    self.viewHUD.layer.masksToBounds = YES;
    self.viewHUD.backgroundColor = [UIColor colorWithWhite:1.0f
                                                     alpha:0.7f];
    if (self.loadingType == LoadingTypeLoading) {
        self.lblLoading.text = @"Carregando...";
    }
    else if (self.loadingType == LoadingTypeLogin) {
        self.lblLoading.text = @"Verificando...";
    }
    else if (self.loadingType == LoadingTypeCustom) {
        self.lblLoading.text = self.customTitle;
    }
}

- (void)setupBlurView {

    [self.view addSubviewAndFillWithContent:self.viewBlur];
    [self.view sendSubviewToBack:self.viewBlur];
}

#pragma mark - Public Methods

- (void)removeFromSuperViewCompletion:(void (^)(BOOL finished))completion {

    [self.view removeFromSuperViewAnimatedCompletion:completion];
}

- (void)removeFromSuperView {

    [self.view removeFromSuperViewAnimatedCompletion:nil];
}


@end