#import <Foundation/Foundation.h>

@interface ZPPOrderManager : NSObject

@property (strong, nonatomic, readonly) NSArray *onTheWayOrders;;

+ (ZPPOrderManager *)sharedManager;

- (void)updateOrdersCompletion:(void (^)(NSInteger count))completion;

@end
