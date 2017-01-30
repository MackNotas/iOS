//
//  SobreViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 10/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "SobreViewController.h"

@interface SobreViewController ()
/**
 *  Views
 */
@property (strong, nonatomic) IBOutlet UIImageView *imgViewLogo;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

/**
 *  Labels
 */
@property (strong, nonatomic) IBOutlet UILabel *lblVersion;

/**
 *  Arrays
 */
@property (nonatomic) NSArray *arrayNomes;
@property (nonatomic) NSArray *arrayTitleHeaders;

@end

@implementation SobreViewController

- (instancetype)init {

    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];

    if (self) {
        self.title = @"Sobre";
        _arrayNomes = @[@[@"Caio Remedio (iOS)",
                            @"Giovanni Cornachini (Android)"],
                            @[@"Pedro Miranda",
                              @"Vinicius Augusto"]];
        _arrayTitleHeaders = @[@"DESENVOLVEDORES:",
                               @"COLABORADORES:"];
    }

    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.imgViewLogo.layer.cornerRadius = self.imgViewLogo.frame.size.height/4;
    self.imgViewLogo.layer.masksToBounds = YES;
    [self.tableView registerClass:[UITableViewCell class]
           forCellReuseIdentifier:@"cellNome"];
    [self setVersionNumber];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [GAHelper trackViewWithName:NSStringFromClass(self.class)];
}

#pragma mark - Private Methods

- (void)setVersionNumber {

    NSString *stringBuild =  [[NSBundle mainBundle]
                               objectForInfoDictionaryKey:@"CFBundleVersion"];

    NSString *stringVerion =  [[NSBundle mainBundle]
                               objectForInfoDictionaryKey:@"CFBundleShortVersionString"];

    NSMutableAttributedString *attVersion = [NSMutableAttributedString new];

    NSMutableParagraphStyle *paragraphCenter = [NSMutableParagraphStyle new];
    [paragraphCenter setAlignment:NSTextAlignmentCenter];


    [attVersion appendAttributedString:[[NSAttributedString alloc]
                                        initWithString:fstr(@"v%@", stringVerion)
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                     NSParagraphStyleAttributeName : paragraphCenter}
                                        ]];


    [attVersion appendAttributedString:[[NSAttributedString alloc]
                                        initWithString:fstr(@" (Build %@)", stringBuild)
                                        attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:17.0f],
                                                     NSParagraphStyleAttributeName : paragraphCenter,
                                                     NSForegroundColorAttributeName : [UIColor lightGrayColor]}
                                        ]];

    self.lblVersion.attributedText = attVersion;

}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.arrayNomes.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return [self.arrayNomes[section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cellNome"
                                                            forIndexPath:indexPath];

    cell.textLabel.text = self.arrayNomes[indexPath.section][indexPath.row];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    return self.arrayTitleHeaders[section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 33.0f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


@end
