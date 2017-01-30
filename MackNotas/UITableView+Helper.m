//
//  UITableView+Helper.m
//  MackNotas
//
//  Created by Caio Remedio on 27/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "UITableView+Helper.h"

@implementation UITableView (Helper)

- (void)reloadAllSections:(NSInteger)allSections {

    [self reloadAllSections:allSections
           withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadAllSections:(NSInteger)allSections
         withRowAnimation:(UITableViewRowAnimation)animation {

    [self beginUpdates];
    [self reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allSections)]
        withRowAnimation:animation];
    [self endUpdates];
}

- (void)reloadAllSectionsIfEmpty:(NSInteger)allSections {

    [self beginUpdates];
    [self insertSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, allSections)]
                  withRowAnimation:UITableViewRowAnimationTop];
    [self endUpdates];

}

- (void)reloadSection:(NSInteger)section
     withRowAnimation:(UITableViewRowAnimation)animation {

    [self beginUpdates];
    [self reloadSections:[NSIndexSet indexSetWithIndex:section]
        withRowAnimation:animation];
    [self endUpdates];
}

- (void)reloadSection:(NSInteger)section {

    [self reloadSection:section
       withRowAnimation:UITableViewRowAnimationAutomatic];
}

- (void)reloadSections:(NSArray *)sections {

    NSMutableIndexSet *multableIndex = [NSMutableIndexSet indexSet];

    for (NSNumber *section in sections) {
        [multableIndex addIndex:section.integerValue];
    }

    [self beginUpdates];
    [self reloadSections:multableIndex
        withRowAnimation:UITableViewRowAnimationAutomatic];
    [self endUpdates];
}

@end
