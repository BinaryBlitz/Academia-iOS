//
//  ZPPOrderManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 30/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderManager.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"
#import "ZPPOrder.h"

@interface ZPPOrderManager()

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
        //_isOpen = YES;
    }
    return self;
}


- (void)updateOrdersCompletion:(void(^)(NSInteger count))completion  {
    
    [[ZPPServerManager sharedManager] GETOldOrdersOnSuccess:^(NSArray *orders) {
       // [self.refreshControl endRefreshing];
        
        [self parseOrders:orders];
        
        if(completion) {
            completion(self.onTheWayOrders.count);
        }
        
       // [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        
        if(completion) {
            completion(-1);
        }
       // [self.refreshControl endRefreshing];
        
       // [self showWarningWithText:ZPPNoInternetConnectionMessage];
    }];
}

- (void)parseOrders:(NSArray *)orders {
    NSMutableArray *onTheWayOrders = [NSMutableArray array];
    NSMutableArray *payedOrders = [NSMutableArray array];
    
    for(ZPPOrder *order in orders) {
        if(order.orderStatus == ZPPOrderStatusOnTheWay) {
            [onTheWayOrders addObject:order];
        } else if (order.orderStatus == ZPPOrderStatusDelivered) {
            [payedOrders addObject:order];
        }
    }
    
    self.onTheWayOrders = [NSArray arrayWithArray:onTheWayOrders];
   // self.doneOrders = [NSArray arrayWithArray:payedOrders];
    //[self.tableView reloadData];
}


@end
