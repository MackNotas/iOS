//
//  GenericSwitchCell.h
//  MackNotas
//
//  Created by Caio Remedio on 01/05/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GenericSwitchCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UISwitch *swtichOption;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;

@property (nonatomic) NSArray *arrayTitles;

- (void)loadWithTitleForRow:(NSInteger)row andTarget:(id)target;

@end
