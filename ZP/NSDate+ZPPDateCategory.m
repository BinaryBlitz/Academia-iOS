//
//  NSDate+ZPPDateCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "NSDate+ZPPDateCategory.h"
#import <DateTools.h>

@implementation NSDate (ZPPDateCategory)

- (NSString *)timeStringfromDate {
    NSString *minuteString = [[self class] zpp_formatedNum:[self minute]];

    NSString *hourString = [[self class] zpp_formatedNum:[self hour]];

    return [NSString stringWithFormat:@"%@:%@", hourString, minuteString];
}

+ (NSString *)zpp_formatedNum:(NSInteger)num {
    return num < 10 ? [NSString stringWithFormat:@"0%ld", (long)num]
                    : [NSString stringWithFormat:@"%ld", num];
}


@end
