//
//  WebViewController.h
//  MackNotas
//
//  Created by Caio Remedio on 13/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController <UIWebViewDelegate>

- (instancetype)initWithURL:(NSString *)url;

@end
