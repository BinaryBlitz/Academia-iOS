//
//  ZPPTimeManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 25/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPTimeManager.h"

@import DateTools;
#import "NSDate+ZPPDateCategory.h"


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

+ (ZPPTimeManager *)timeManagerWith:(NSArray *)managerData {
    ZPPTimeManager *timeManager = [ZPPTimeManager new];
    
    NSMutableArray *openHoursGroup = [NSMutableArray array];
    for (NSDictionary *dict in managerData) {
        NSString *currentDateString = dict[@"current_time"];
        timeManager.currentTime = [NSDate customDateFromString:currentDateString];
        NSDate *currentTime = [NSDate dateWithTimeIntervalSince1970:timeManager.currentTime.timeIntervalSince1970];
        NSDate *tmpDate = [NSDate dateWithYear:[currentTime year] month:[currentTime month]
                                           day:[currentTime day] hour: 0 minute: 0 second: 0];
        NSNumber *startHour = dict[@"start_hour"];
        NSNumber *startMinute = dict[@"start_min"];
        NSNumber *endHour = dict[@"end_hour"];
        NSNumber *endMinute = dict[@"end_min"];
        NSDate *startDate = [[tmpDate dateByAddingHours:[startHour integerValue]] dateByAddingMinutes:[startMinute integerValue]];
        NSDate *endDate = [[tmpDate dateByAddingHours:[endHour integerValue]] dateByAddingMinutes:[endMinute integerValue]];
        
        DTTimePeriod *timePeriod = [DTTimePeriod timePeriodWithStartDate:startDate endDate:endDate];
        [openHoursGroup addObject:timePeriod];
    }
    [openHoursGroup sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        DTTimePeriod *first = (DTTimePeriod *)obj1;
        DTTimePeriod *second = (DTTimePeriod *)obj2;
        return [first.StartDate isEarlierThan:second.StartDate] ? NSOrderedAscending : NSOrderedDescending;
    }];
    
    timeManager.openTimePeriodChain = [NSArray arrayWithArray:openHoursGroup];
    
    return timeManager;
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

@end
