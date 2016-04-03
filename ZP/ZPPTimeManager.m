//
//  ZPPTimeManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 25/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPTimeManager.h"
#import "NSDate+ZPPDateCategory.h"
#

@interface ZPPTimeManager ()

@property (assign, nonatomic) BOOL isOpen;
@property (strong, nonatomic) NSDate *openTime;
@property (strong, nonatomic) NSDate *currentTime;
@property (assign, nonatomic) BOOL dishesForToday;

@end

@implementation ZPPTimeManager

+ (ZPPTimeManager *)sharedManager {
    static ZPPTimeManager *manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZPPTimeManager alloc] init];
    });

    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        _isOpen = NO;
    }
    return self;
}

- (void)configureWithDict:(NSDictionary *)dict {
    id isOpen = dict[@"is_open"];

    if (isOpen && ![isOpen isEqual:[NSNull null]]) {
        self.isOpen = [isOpen boolValue];
    }

    NSString *openTimeString = dict[@"opens_at"];
    NSString *curentTimeString = dict[@"current_time"];

    //    2015-11-28T12:00:00.000+03:00

    if (![openTimeString isEqual:[NSNull null]]) {
        self.openTime = [NSDate customDateFromString:openTimeString];
    }
    if (![curentTimeString isEqual:[NSNull null]]) {
        self.currentTime = [NSDate customDateFromString:curentTimeString];
    }

    NSArray *lunches = dict[@"lunches"];
    NSArray *dishes = dict[@"dishes"];

    if (![lunches isEqual:[NSNull null]] && lunches.count > 0 ) {
        self.dishesForToday = YES;
    }
    
    if(![dishes isEqual:[NSNull null]] && dishes.count > 0) {
        self.dishesForToday = YES;
    }
}

//- (void)resetTimeManager {
//    self.isOpen = YES;
//    self.openTime = nil;
//    self.currentTime = nil;
//}

@end
