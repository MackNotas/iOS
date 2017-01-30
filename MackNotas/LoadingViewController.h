//
//  LoadingViewController.h
//  LoadingTeste
//
//  Created by Caio Remedio on 06/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LoadingType) {
    LoadingTypeLogin,
    LoadingTypeLoading,
    LoadingTypeCustom
};

@interface LoadingViewController : UIViewController

- (instancetype)initWithLoadingType:(LoadingType)loadingType;
- (void)removeFromSuperView;
- (void)removeFromSuperViewCompletion:(void (^)(BOOL finished))completion;
- (instancetype)initWithCustomTitle:(NSString *)customTitle;

@end
