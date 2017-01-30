//
//  ServerStatusCell.h
//  MackNotas
//
//  Created by Caio Remedio on 01/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ServerStatusCell : UITableViewCell
/**
 *  Views
 */
@property (strong, nonatomic) IBOutlet UILabel *lblServiceName;
@property (strong, nonatomic) IBOutlet UIImageView *imgViewStatus;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *acLoading;

/**
 * Array
 */
@property (nonatomic) NSArray *arrayLblTitle;


- (void)loadWithServerStatus:(BOOL)isOnline andTitleForRow:(NSUInteger)row hasReloaded:(BOOL)hasReloaded;

@end
