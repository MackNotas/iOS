//
//  GeneralHelper.h
//  MackNotas
//
//  Created by Caio Remedio on 26/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GeneralHelper : NSObject

+ (NSString *)pathForUserDataFile;
+ (NSString *)pathForDBFile;
+ (NSString *)updatedTodayAt;
+ (NSString *)getDeviceModel;
+ (NSString *)getOSVersion;
+ (NSURLRequest *)requestWithString:(NSString *)url;


+ (UIBarButtonItem *)barButtonWithLoadingStatus:(BOOL)isLoading;

+ (void)showActivityIndicatorOnNavBarRight:(BOOL)shouldShow
                         WithRefreshButton:(UIBarButtonItem *)refreshBtn
                         andNavigationItem:(UINavigationItem *)navItem;
/**
 *  Get the current date and check if we are in the First Semester of the Year
 *
 *  @return YES if we are in the first semester of the year. NO if we are in the second semester
 */
+ (BOOL)isOnFirstSemester;
+ (NSInteger)currentMonth;
+ (NSInteger)currentDay;
+ (NSInteger)currentWeekDayNumber;
+ (NSInteger)currentMonthForArray;
+ (BOOL)isTodayWithDay:(NSString *)day andMonth:(NSString *)month;
+ (BOOL)isTomorrowWithDay:(NSString *)day andMonth:(NSString *)month;
+ (BOOL)isEmailValid:(NSString *)email;
+ (NSString *)decodeJSON:(NSArray *)JSON;

@end
