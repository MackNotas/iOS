//
//  WebViewController.m
//  MackNotas
//
//  Created by Caio Remedio on 13/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "WebViewController.h"

/**
 *  Helpers
 */
#import "ConnectionHelper.h"

@interface WebViewController ()

/**
 *  Views
 */
@property (strong, nonatomic) IBOutlet UIWebView *webView;

/**
 *  Obecjts
 */
@property (nonatomic) NSString *url;

/**
 BarButtons
 */

@property (nonatomic) UIBarButtonItem *barBtnStop;
@property (nonatomic) UIBarButtonItem *barBtnRefresh;


@end

@implementation WebViewController

- (instancetype)initWithURL:(NSString *)url {

    self = [super initWithNibName:NSStringFromClass(self.class) bundle:nil];

    if (self) {
        self.url = url;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]
                                             initWithTitle:@"Fechar"
                                             style:UIBarButtonItemStylePlain
                                             target:self
                                             action:@selector(dismissViewController)];

    self.navigationItem.rightBarButtonItems = @[self.barBtnRefresh,
                                                self.barBtnStop];

    [self.webView loadRequest:[GeneralHelper requestWithString:self.url]];
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

- (void)dismissViewController {

    [self.webView stopLoading];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}

- (void)refreshWebView {
    if (self.webView.request.URL) {
        [self.webView reload];
    }
    else {
        [self.webView loadRequest:[GeneralHelper requestWithString:self.url]];
    }
}

- (void)stopWebView {

    [self.webView stopLoading];
}

#pragma mark - UIWebViewDelagate

- (void)webViewDidStartLoad:(UIWebView *)webView {

    [ConnectionHelper startActivityIndicator];
    self.barBtnStop.enabled = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [ConnectionHelper stopActivityIndicator];
    self.barBtnStop.enabled = NO;
    NSString *viewTitle = [[webView
                            stringByEvaluatingJavaScriptFromString:@"document.title"]
                           stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    self.title = viewTitle;
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {

    [ConnectionHelper stopActivityIndicator];
    self.barBtnStop.enabled = NO;
    if (error.code != -999) {
        [[UIAlertView alertViewAllFailedWithError:error] show];
    }
}

#pragma mark - Properties Override

- (UIBarButtonItem *)barBtnRefresh {

    if (_barBtnRefresh) {
        return _barBtnRefresh;
    }

    _barBtnRefresh = [[UIBarButtonItem alloc]
                      initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh
                      target:self
                      action:@selector(refreshWebView)];

    return _barBtnRefresh;
}

- (UIBarButtonItem *)barBtnStop {

    if (_barBtnStop) {
        return _barBtnStop;
    }

    _barBtnStop = [[UIBarButtonItem alloc]
                   initWithBarButtonSystemItem:UIBarButtonSystemItemStop
                   target:self.webView
                   action:@selector(stopLoading)];

    return _barBtnStop;
}

@end
