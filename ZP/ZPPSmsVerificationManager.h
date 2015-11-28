//
//  ZPPSmsVerificationManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

extern const NSInteger ZPPMaxCount;

@interface ZPPSmsVerificationManager : NSObject

@property (assign, nonatomic, readonly) NSInteger currentTime;

@property (nonatomic, copy) void (^timerCounter)(NSInteger time);

+ (instancetype)shared;

//- (void)POSTCode:(NSString *)code
//        toNumber:(NSString *)number
//       onSuccess:(void (^)())success
//       onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)startTimer;
- (void)invalidateTimer;

- (BOOL)canSendAgain;

@end
