//
//  GeneralHelper.m
//  MackNotas
//
//  Created by Caio Remedio on 26/04/15.
//  Copyright (c) 2015 Caio Remedio. All rights reserved.
//

#import "GeneralHelper.h"
#import "LocalUser.h"

#include <sys/sysctl.h>
#include <sys/utsname.h>

@implementation GeneralHelper

#pragma mark - Methods

+ (NSString *)pathForUserDataFile {

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    return [path stringByAppendingPathComponent:DATA_FILE_NAME];
}

+ (NSString *)pathForDBFile {

    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];

    return [path stringByAppendingPathComponent:DATA_DATABASE_FILE];
}

+ (NSString *)updatedTodayAt {
    NSDateFormatter *dF = [NSDateFormatter new];
    NSDate *agoraDate = [NSDate date];

    [dF setDateFormat:@"'Hoje às 'HH:mm"];

    return [dF stringFromDate:agoraDate];
}

+ (NSString *)getDeviceModel {

    struct utsname systemInfo;
    uname(&systemInfo);
    return [NSString stringWithCString:systemInfo.machine
                              encoding:NSUTF8StringEncoding];

}

+ (NSString *)getOSVersion {

    return [UIDevice currentDevice].systemVersion;
}

+ (NSString *)decodeJSON:(NSArray *)JSON {

    NSData *buffer = [NSKeyedArchiver archivedDataWithRootObject:JSON];
    NSMutableArray *arrayJSON_copy = [NSKeyedUnarchiver unarchiveObjectWithData:buffer];

    NSError *error;
    NSData *jsonData = [NSJSONSerialization
                        dataWithJSONObject:arrayJSON_copy
                        options:NSJSONWritingPrettyPrinted
                        error:&error];
    NSString *json_stringfied = [[NSString alloc] initWithData:jsonData
                                                      encoding:NSUTF8StringEncoding];

    return json_stringfied;
}

+ (NSURLRequest *)requestWithString:(NSString *)url {

    return [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
}

+ (UIBarButtonItem *)barButtonWithLoadingStatus:(BOOL)isLoading {

    UIBarButtonItem *barBtn;

    if (isLoading) {
        UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc]
                                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        barBtn = [[UIBarButtonItem alloc] initWithCustomView:actInd];
    }
    else {

    }

    return barBtn;
}

+ (void)showActivityIndicatorOnNavBarRight:(BOOL)shouldShow
                         WithRefreshButton:(UIBarButtonItem *)refreshBtn
                         andNavigationItem:(UINavigationItem *)navItem {

    UIBarButtonItem *btn;

    if (shouldShow) {
        UIActivityIndicatorView *actInd = [[UIActivityIndicatorView alloc]
                                           initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [actInd startAnimating];
        btn.enabled = NO;
        btn = [[UIBarButtonItem alloc] initWithCustomView:actInd];
    }
    else {
        btn = refreshBtn;
    }

    [UIView animateWithDuration:0.4f animations:^{
        navItem.rightBarButtonItem.customView.alpha = shouldShow ? 1.0f : 0.0f;
    } completion:^(BOOL finished) {
        navItem.rightBarButtonItem = btn;
    }];
}

#pragma mark - Dates Methods

+ (BOOL)isOnFirstSemester {

    return [GeneralHelper currentMonth] < 8;
}

+ (NSInteger)currentMonth {

    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM"];

    return [formatter stringFromDate:today].integerValue;
}

+ (NSInteger)currentMonthForArray {

    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"MM"];

    NSInteger currentMonth = [formatter stringFromDate:today].integerValue;

    if (currentMonth < 8) {
        return currentMonth - 1;
    }

    return currentMonth - 8;
}

+ (NSInteger)currentDay {

    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"dd"];

    return [formatter stringFromDate:today].integerValue;
}

+ (NSInteger)currentWeekDayNumber {

    NSDate *today = [NSDate date];
    NSDateFormatter *formatter = [NSDateFormatter new];
    [formatter setDateFormat:@"e"];

    return [formatter stringFromDate:today].integerValue;
}

+ (BOOL)isTodayWithDay:(NSString *)day andMonth:(NSString *)month {

    NSInteger dayNumber = day.integerValue;
    NSInteger monthNumber = month.integerValue;

    return ([self currentDay] == dayNumber &&
            [self currentMonth] == monthNumber);
}

+ (BOOL)isTomorrowWithDay:(NSString *)day andMonth:(NSString *)month {

    NSInteger dayProva = day.integerValue;
    NSInteger monthProva = month.integerValue;


    /**
     *  Para evitar que o dia 31 se transforme em 32, mes 12 -> mes 13 etc...
     */
    NSDateComponents *dayComponent = [NSDateComponents new];
    dayComponent.day = 1;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *tomorrowDate = [calendar dateByAddingComponents:dayComponent
                                                     toDate:[NSDate date]
                                                    options:0];

    NSDateFormatter *dateFormatDay = [NSDateFormatter new];
    dateFormatDay.dateFormat = @"dd";

    NSDateFormatter *dateFormatMonth = [NSDateFormatter new];
    dateFormatMonth.dateFormat = @"MM";

    NSInteger dayTomorrow = [dateFormatDay stringFromDate:tomorrowDate].integerValue;
    NSInteger monthTomorrow = [dateFormatMonth stringFromDate:tomorrowDate].integerValue;

    return (dayProva == dayTomorrow &&
            monthProva == monthTomorrow);
}

+ (BOOL)isEmailValid:(NSString *)email {

    NSString *emailRegEx =
    @"(?:[a-z0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'*+/=?\\^_`{|}"
    @"~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"
    @"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[a-z0-9](?:[a-"
    @"z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\\[(?:(?:25[0-5"
    @"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"
    @"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"
    @"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])";

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];

    return [predicate evaluateWithObject:email];
}


@end
