#import <Foundation/Foundation.h>

extern const NSInteger ZPPMaxCount;

@interface ZPPSmsVerificationManager : NSObject

@property (assign, nonatomic, readonly) NSInteger currentTime;

@property (nonatomic, copy) void (^timerCounter)(NSInteger time);

+ (instancetype)shared;
- (void)startTimer;
- (void)invalidateTimer;
- (BOOL)canSendAgain;

@end
