#import "ZPPOrderManager.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"
#import "ZPPOrder.h"

@interface ZPPOrderManager ()

@property (strong, nonatomic) NSArray *onTheWayOrders;

@end

@implementation ZPPOrderManager

+ (ZPPOrderManager *)sharedManager {
  static ZPPOrderManager *manager = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ZPPOrderManager alloc] init];
  });

  return manager;
}

- (id)init {
  self = [super init];

  if (self) {
  }

  return self;
}

- (void)updateOrdersCompletion:(void (^)(NSInteger count))completion {

  [[ZPPServerManager sharedManager] GETOldOrdersOnSuccess:^(NSArray *orders) {
    [self parseOrders:orders];

    if (completion) {
      completion(self.onTheWayOrders.count);
    }
  }                                             onFailure:^(NSError *error, NSInteger statusCode) {

    if (completion) {
      completion(-1);
    }
  }];
}

- (void)parseOrders:(NSArray *)orders {
  NSMutableArray *onTheWayOrders = [NSMutableArray array];
  NSMutableArray *payedOrders = [NSMutableArray array];

  for (ZPPOrder *order in orders) {
    if (order.orderStatus == ZPPOrderStatusOnTheWay) {
      [onTheWayOrders addObject:order];
    } else if (order.orderStatus == ZPPOrderStatusDelivered) {
      [payedOrders addObject:order];
    }
  }

  self.onTheWayOrders = [NSArray arrayWithArray:onTheWayOrders];
}

@end
