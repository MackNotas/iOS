//
//  DesempenhoViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 23/08/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "DesempenhoViewController.h"
#import "ConnectionHelper.h"

@interface DesempenhoViewController ()// <ChartViewDelegate>
//@property (strong, nonatomic) IBOutlet LineChartView *lineChartView;
//@property (nonatomic, strong) IBOutlet NSArray *options;

@end

@implementation DesempenhoViewController

- (instancetype)init {

    if ((self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil])) {
        self.title = @"Desempenho Semestral";
    }
    return self;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    [self initializeLineChartView];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [self requestDesempenhoSkippingCache:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Initialize Methods

- (void)initializeLineChartView {

//    self.lineChartView.noDataText = @"Carregando...";
//    self.lineChartView.drawGridBackgroundEnabled = NO;
//    self.lineChartView.highlightEnabled = YES;
//    self.lineChartView.userInteractionEnabled = NO;
//    self.lineChartView.dragEnabled = NO;
//    self.lineChartView.scaleXEnabled = NO;
}

#pragma mark - Line Chart Setup

- (void)setupLineChartDataWithNotas:(NSArray *)notasResponse semestres:(NSArray *)semestresResponse {

//    NSMutableArray *notas = [NSMutableArray arrayWithCapacity:notasResponse.count];
//
//    for (int i = 0; i < notasResponse.count; i++) {
//        NSString *nota = notasResponse[i];
//        [notas addObject:[[ChartDataEntry alloc] initWithValue:nota.doubleValue
//                                                        xIndex:i]];
//    }
//
//    LineChartDataSet *dataSet = [[LineChartDataSet alloc] initWithYVals:notas label:@"Desempenho Semestral"];
//    dataSet.colors = @[[UIColor vermelhoMainBackground]];
//    dataSet.circleColors = @[[UIColor blackColor]];
//    dataSet.lineWidth = 10.0f;
//    dataSet.circleRadius = 10.0f;
//    dataSet.drawCircleHoleEnabled = YES;
//    dataSet.fillColor = [UIColor blackColor];
//
//    LineChartData *chartData = [[LineChartData alloc] initWithXVals:semestresResponse
//                                                            dataSet:dataSet];
//    self.lineChartView.data = chartData;
}

#pragma mark - Request Methods

- (void)requestDesempenhoSkippingCache:(BOOL)skipCache {

    [[ConnectionHelper sharedClient] requestDesempenhoWithBlockSuccess:^(NSURLSessionDataTask *task, id responseObject) {

        [ConnectionHelper stopActivityIndicator];

        if ([responseObject[@"semestrenotas"] isKindOfClass:[NSArray class]]) {
            if ([responseObject[@"semestrenotas"] count] == 0) {
//                self.lineChartView.noDataText = @"Não foi possível calcular suas médias semestrais!";
                return;
            }
        }

        [self setupLineChartDataWithNotas:responseObject[@"semestrenotas"]
                                semestres:responseObject[@"semestre"]];

//        CGFloat mediaGeral = [responseObject[@"mediageral"] doubleValue];
//        ChartLimitLine *ll1 = [[ChartLimitLine alloc] initWithLimit:mediaGeral label:@"Média"];
//        ll1.lineWidth = 4.0;
//        ll1.lineDashLengths = @[@5.f, @5.f];
//        ll1.labelPosition = ChartLimitLabelPositionRightTop;
//        ll1.valueFont = [UIFont systemFontOfSize:10.0];
//
//        ChartYAxis *leftAxis = self.lineChartView.leftAxis;
//        [leftAxis removeAllLimitLines];
//        [leftAxis addLimitLine:ll1];
//        leftAxis.customAxisMax = 10.0f;
//        leftAxis.customAxisMin = 0.0f;
//        leftAxis.startAtZeroEnabled = NO;
//        leftAxis.gridLineDashLengths = @[@5.f, @5.f];
//        leftAxis.drawLimitLinesBehindDataEnabled = YES;

    } andBlockFailure:^(NSURLSessionDataTask *task, NSError *error) {
//        self.lineChartView.noDataText = @"Erro ao obter desempenho.";
//        self.lineChartView.noDataTextDescription = @"Tente novamente mais tarde";
    }];
}

@end
