#import "ZPPServerManager.h"

@class ZPPTimeManager;

@interface ZPPServerManager (ZPPDishesSeverManager)

- (void)getCategoriesOnSuccess:(void (^)(NSArray *categories))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getDishesWithCategory:(NSNumber *) categoryId
                    onSuccess:(void (^)(NSArray *dishes))success
                    onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getDayMenu;

@end
