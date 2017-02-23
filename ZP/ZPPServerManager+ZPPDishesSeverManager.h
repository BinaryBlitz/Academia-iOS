#import "ZPPServerManager.h"

@class ZPPTimeManager;

@interface ZPPServerManager (ZPPDishesSeverManager)

- (void)GETDishesOnSuccesOnSuccess:(void (^)(NSArray *dishes))success
                         onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getDayMenuOnSuccess:(void (^)(NSArray *meals, NSArray *dishes, NSArray *stuff, ZPPTimeManager *timeManager))success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
