//
//  ZPPServerManager+ZPPDishesSeverManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager.h"

@interface ZPPServerManager (ZPPDishesSeverManager)

- (void)GETDishesOnSuccesOnSuccess:(void (^)(NSArray *dishes))success
                         onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getDayMenuOnSuccess:(void (^)(NSArray *meals, NSArray *dishes, NSArray *stuff))success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
