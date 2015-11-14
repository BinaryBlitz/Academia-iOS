//
//  ZPPSmsVerificationManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPSmsVerificationManager.h"
#import <AFNetworking.h>

#import "ZPPConsts.h"

const NSInteger ZPPMaxCount = 60;

@interface ZPPSmsVerificationManager ()

@property (strong, nonatomic) NSTimer *timer;
@property (assign, nonatomic) NSInteger currentTime;

@end

@implementation ZPPSmsVerificationManager

+ (instancetype)shared {
    static ZPPSmsVerificationManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZPPSmsVerificationManager alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.currentTime = -1;
        // [self propertiesInitializing];
    }
    return self;
}

- (void)POSTCode:(NSString *)code
        toNumber:(NSString *)number
       onSuccess:(void (^)())success
       onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

    NSString *url = [NSString stringWithFormat:@"http://sms.ru/sms/send"];
    NSString *text = [NSString stringWithFormat:@"Код %@", code];
    NSDictionary *params = @{ @"api_id" : ZPPSMSAppID, @"to" : number, @"text" : text };

    [manager POST:url
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            if (success) {
                success();
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSLog(@"error %@", error);

            if (operation.response.statusCode == 200) {
                if (success) {
                    success();
                }
                return;
            }
            if (failure) {
                failure(error, operation.response.statusCode);
            }
        }];
}

- (void)startTimer {
    [self invalidateTimer];
    self.currentTime = 0;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timerTick:)
                                                userInfo:nil
                                                 repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

- (void)timerTick:(NSTimer *)timer {
    if (![timer isEqual:self.timer]) {
        [timer invalidate];
        timer = nil;
    }

    if (self.currentTime < ZPPMaxCount) {
        self.currentTime++;
        self.timerCounter(self.currentTime);
    } else {
        //        self.timerCounter(-1);
        //        [self.timer invalidate];
        //        self.timer = nil;
        //        self.currentTime = -1;
        [self invalidateTimer];
    }
}

- (void)invalidateTimer {
    [self.timer invalidate];
    self.timer = nil;
    self.currentTime = -1;
    if (self.timerCounter) {
        self.timerCounter(-1);
    }
}

- (BOOL)canSendAgain {
    return self.currentTime == -1;
}

@end
