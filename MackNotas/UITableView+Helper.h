//
//  UITableView+Helper.h
//  MackNotas
//
//  Created by Caio Remedio on 27/06/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Helper)

/**
 *  Reload all sections with Automatic animation
 *
 *  @param allSections The total number of sections
 */
- (void)reloadAllSections:(NSInteger)allSections;

/**
 *  Reload all sections. Should be used when tableView is empty to avoid update crash.
 *  AnimationTop is used.
 *
 *  @param allSections The total number of sections
 */
- (void)reloadAllSectionsIfEmpty:(NSInteger)allSections;

/**
 *  Reload the only given section with Automatic animation.
 *
 *  @param section The number of section to be reloaded
 */
- (void)reloadSection:(NSInteger)section;

/**
 *  Reload only the given sections with Automatic Animation.
 *
 *  @param sections The sections to be reloaded as a NSNumber
 */
- (void)reloadSections:(NSArray *)sections;

- (void)reloadSection:(NSInteger)section
     withRowAnimation:(UITableViewRowAnimation)animation;

/**
 *  Reload all sections using by passing an UITableViewRowAnimation.
 *
 *  @param allSections The total number of section.
 *  @param animation   Desired animation.
 */
- (void)reloadAllSections:(NSInteger)allSections
         withRowAnimation:(UITableViewRowAnimation)animation;

@end
