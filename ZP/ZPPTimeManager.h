@import Foundation;

@interface ZPPTimeManager : NSObject
extern NSString *const ZPPTimeManagerDidUpdateNotificationName;

@property (assign, nonatomic, readonly) BOOL isOpen;
@property (strong, nonatomic, readonly) NSDate *openTime;
@property (strong, nonatomic, readonly) NSDate *currentTime;
@property (assign, nonatomic, readonly) BOOL dishesForToday;

@property (strong, nonatomic) NSArray *openTimePeriodChain;

+ (ZPPTimeManager *)sharedManager;
+ (ZPPTimeManager *)timeManagerWith:(NSDictionary *)dict;

- (void)configureWithDict:(NSDictionary *)dict;

@end
