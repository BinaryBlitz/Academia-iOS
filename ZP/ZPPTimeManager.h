//
//  ZPPTimeManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 25/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import Foundation;

@interface ZPPTimeManager : NSObject

@property (assign, nonatomic, readonly) BOOL isOpen;
@property (strong, nonatomic, readonly) NSDate *openTime;
@property (strong, nonatomic, readonly) NSDate *currentTime;
@property (assign, nonatomic, readonly) BOOL dishesForToday;

@property (strong, nonatomic) NSArray *openTimePeriodChain;

+ (ZPPTimeManager *)sharedManager;
+ (ZPPTimeManager *)timeManagerWith:(NSDictionary *)dict;

- (void)configureWithDict:(NSDictionary *)dict;

@end
