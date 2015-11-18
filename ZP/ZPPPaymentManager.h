//
//  ZPPPaymentManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
@class ZPPOrder;

// extern NSString *const ZPPPaymnetBaseURL;

extern NSString *const ZPPPaymentFinishURL;
extern NSString *const ZPPCentralURL;

@interface ZPPPaymentManager : NSObject

@property (copy, nonatomic, readonly) NSString *baseURL;

+ (ZPPPaymentManager *)sharedManager;

- (void)registrateWithOrderNum:(NSString *)orderNumber
                     onSuccess:(void (^)(NSURL *url, NSString *orderIDAlfa))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getOrderStatus:(NSString *)orderId
             onSuccess:(void (^)(NSString *bindingID))success
             onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)postOrderWithBindingID:(NSString *)bindingId
                          cost:(NSInteger)cost
                         descr:(NSString *)descr
                     onSuccess:(void (^)(NSURL *url, NSString *orderIDAlfa))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)registrateOrder:(ZPPOrder *)order
              onSuccess:(void (^)(NSURL *url, NSString *orderIDAlfa))success
              onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
