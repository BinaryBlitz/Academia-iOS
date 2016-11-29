//
//  NSDate+ZPPDateCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "NSDate+ZPPDateCategory.h"
//#import <DateTools.h>
@import DateTools;

@implementation NSDate (ZPPDateCategory)

- (NSString *)timeStringfromDate {
    NSString *minuteString = [[self class] zpp_formatedNum:[self minute]];

    NSString *hourString = [[self class] zpp_formatedNum:[self hour]];

    return [NSString stringWithFormat:@"%@:%@", hourString, minuteString];
}

- (NSString *)dateStringFromDate {
//    NSString *day = [self day];

    return [NSString stringWithFormat:@"%ld.%ld",(long)[self day], (long)[self month]];

}

+ (NSString *)zpp_formatedNum:(NSInteger)num {
    return num < 10 ? [NSString stringWithFormat:@"0%ld", (long)num]
                    : [NSString stringWithFormat:@"%ld", (long)num];
}


+ (NSDate *)customDateFromString:(NSString *)dateAsString {


    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";

//    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    df.locale = [NSLocale systemLocale];

    return [df dateFromString:dateAsString];
}

//2015-11-28T12:00:00.000+03:00

+ (NSDate *)customDateFromstringWithRegion:(NSString *)dateString {

//    NSDateFormatter *df = [[NSDateFormatter alloc] init];
//    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ";
//    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
//    df.locale = [NSLocale systemLocale];
//
//    return [df dateFromString:dateString];

//    NSString *dateString = @"2013-04-18T08:49:58.157+0000";
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    // Always use this locale when parsing fixed format date strings
    NSLocale *posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setLocale:posix];
    NSDate *date = [formatter dateFromString:dateString];
    NSLog(@"date = %@", date);

    return date;



}

- (NSString *)serverFormattedString {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];

    df.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss.SSSZ";

//    [df setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    df.locale = [NSLocale systemLocale];

    return [df stringFromDate:self];
}

@end
