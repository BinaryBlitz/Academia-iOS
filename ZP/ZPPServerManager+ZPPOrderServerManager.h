//
//  ZPPServerManager+ZPPOrderServerManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager.h"

@class ZPPOrder;
@interface ZPPServerManager (ZPPOrderServerManager)

- (void)GETOldOrdersOnSuccess:(void (^)(NSArray *orders))success
                    onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)POSTOrder:(ZPPOrder *)order
        onSuccess:(void (^)(ZPPOrder *order))success
        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)POSTPaymentWithOrderID:(NSString *)orderID
                     onSuccess:(void (^)(NSString *paymnetURL))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)checkPaymentWithID:(NSString *)orderID
                 onSuccess:(void (^)(NSInteger sta))success
                 onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;


#pragma mark - review

- (void)sendComment:(NSString *)comment
     forOrderWithID:(NSString *)orderID
          onSuccess:(void (^)())success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)patchStarsWithValue:(NSNumber *)starValue
             forOrderWithID:(NSString *)orderID
                  onSuccess:(void (^)())success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

#pragma mark - geo

- (void)getPoligonPointsOnSuccess:(void (^)(NSArray *points))success
                        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
