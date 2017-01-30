//
//  HorarioGenericViewController.h
//  MackNotas
//
//  Created by Caio Remedio on 02/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MNHorario;

@protocol HorarioGenericViewDelegate <NSObject>

@required
- (void)horarioGenericDidReloadViewId:(NSInteger)viewId;

@end

//=======================================================================

@interface HorarioGenericViewController : UITableViewController

- (void)loadWithHorario:(MNHorario *)horario;
- (void)reloadTableView;
/**
 *  Stop Refresh Control animation "Refreshing"
 */
- (void)stopRefreshing;

@property (nonatomic, assign) id<HorarioGenericViewDelegate> delegate;

@end
