//
//  ZPPOrderManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 30/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPOrderManager : NSObject

@property (strong, nonatomic, readonly) NSArray *onTheWayOrders;;

+ (ZPPOrderManager *)sharedManager;


- (void)updateOrdersCompletion:(void(^)(NSInteger count))completion;

@end
