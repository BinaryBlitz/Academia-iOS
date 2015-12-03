//
//  ZPPTimeManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 25/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPTimeManager : NSObject

@property (assign, nonatomic, readonly) BOOL isOpen;
@property (strong, nonatomic, readonly) NSDate *openTime;
@property (strong, nonatomic, readonly) NSDate *currentTime;
@property (assign, nonatomic, readonly) BOOL dishesForToday;

+ (ZPPTimeManager *)sharedManager;

- (void)configureWithDict:(NSDictionary *)dict;
//- (void)resetTimeManager;



@end
