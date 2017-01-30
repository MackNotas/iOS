//
//  HorarioGenericViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 02/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "HorarioGenericViewController.h"

/**
 Cells
 */
#import "HorarioCell.h"

/**
 *  Models
 */
#import "MNHorario.h"

@interface HorarioGenericViewController ()

@property (nonatomic) NSArray *arrayMaterias;
@property (nonatomic) NSArray *arrayHoras;

@end

@implementation HorarioGenericViewController

- (instancetype)init {

    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        _arrayMaterias = [NSArray new];
        _arrayHoras = [NSArray new];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib
                                 nibWithNibName:NSStringFromClass([HorarioCell class])
                                 bundle:nil]
         forCellReuseIdentifier:NSStringFromClass([HorarioCell class])];

    CGFloat tabBarHeight = self.tabBarController.tabBar.frame.size.height;
    UIEdgeInsets insets = UIEdgeInsetsMake(0.0f,
                                           0.0f,
                                           tabBarHeight,
                                           0.0f);

    self.tableView.contentInset = insets;
    self.tableView.scrollIndicatorInsets = insets;
    self.tableView.showsVerticalScrollIndicator = NO;
    [self setupRefreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];

    if (self.arrayHoras.count > 0 &&
        self.arrayMaterias.count > 0) {
        [self.tableView reloadData];
    }
}

#pragma mark - Setups

- (void)setupRefreshControl {
    self.refreshControl = [UIRefreshControl new];
    [self.refreshControl addTarget:self
                            action:@selector(requestReloadIgnoringCache)
                  forControlEvents:UIControlEventValueChanged];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (self.arrayMaterias) {
        return self.arrayMaterias.count;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HorarioCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([HorarioCell class])
                                                        forIndexPath:indexPath];
    
    [cell loadWithMateria:self.arrayMaterias[indexPath.row]
                  andHora:self.arrayHoras[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath
                             animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return [HorarioCell cellHeight];
}

#pragma mark - Public Methods

- (void)reloadTableView {

    [self.tableView reloadData];
}
- (void)loadWithHorario:(MNHorario *)horario {

    self.arrayHoras = horario.horas;
    self.arrayMaterias = horario.materias;
}

- (void)stopRefreshing {

    [self.refreshControl endRefreshing];
}

#pragma mark - Private Methods

- (void)requestReloadIgnoringCache {

    if ([self.delegate respondsToSelector:@selector(horarioGenericDidReloadViewId:)]) {
        [self.delegate horarioGenericDidReloadViewId:self.restorationIdentifier.integerValue];
    }
}

@end