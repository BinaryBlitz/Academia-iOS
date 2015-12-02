//
//  ZPPServerManager+ZPPOrderServerManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPOrderServerManager.h"
#import <AFNetworking.h>
#import "ZPPUserManager.h"
#import "ZPPOrder.h"
#import "ZPPOrderHelper.h"

@implementation ZPPServerManager (ZPPOrderServerManager)

- (void)GETOldOrdersOnSuccess:(void (^)(NSArray *orders))success
                    onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *params = @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };
    [self.requestOperationManager GET:@"orders.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            NSLog(@"old dicts %@", responseObject);

            NSArray *orders = [ZPPOrderHelper parseOrdersFromDicts:responseObject];

            if (success) {
                success(orders);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];

        }];
}

- (void)POSTOrder:(ZPPOrder *)order
        onSuccess:(void (^)(ZPPOrder *order))success
        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *orderDict = [ZPPOrderHelper orderDictFromOrder:order];

    NSDictionary *params =
        @{ @"order" : orderDict,
           @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };

    [self.requestOperationManager POST:@"orders.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSLog(@"post order %@", responseObject);

            ZPPOrder *o = [ZPPOrderHelper parseOrderFromDict:responseObject];
            if (success) {
                success(o);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

- (void)POSTPaymentWithOrderID:(NSString *)orderID
                     onSuccess:(void (^)(NSString *paymnetURL))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *params = @{
        @"api_token" : [ZPPUserManager sharedInstance].user.apiToken,
        @"payment" : @{@"use_binding" : @"false"}
    };

    NSString *urlString = [NSString stringWithFormat:@"orders/%@/payment.json", orderID];
    [self.requestOperationManager POST:urlString
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            NSLog(@"payment resp %@", responseObject);
            NSString *url = responseObject[@"url"];
            if (success) {
                success(url);
            }

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            if (failure) {
                [[self class] failureWithBlock:failure error:error operation:operation];
            }
        }];
}

- (void)checkPaymentWithID:(NSString *)orderID
                 onSuccess:(void (^)(NSString *sta))success
                 onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *params = @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };

    NSString *urlString = [NSString stringWithFormat:@"orders/%@/payment_status.json", orderID];

    //    static NSInteger count = 0;
    //
    //    count++;
    //
    //    NSLog(@"%ld", count);
    //
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
    //                   dispatch_get_main_queue(), ^{
    //                       if (count < 2) {
    //                           if (failure) {
    //                               failure(nil, 500);
    //                           }
    //                       } else {
    //                           if (success) {
    //                               success(@"Успешно");
    //                           }
    //                       }
    //                   });

    [self.requestOperationManager GET:urlString
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            NSLog(@"payment status response %@", responseObject);

            NSString *s = responseObject[@"status"];
            if (success) {
                success(s);
            }

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

#pragma mark - review

- (void)sendComment:(NSString *)comment
     forOrderWithID:(NSString *)orderID
          onSuccess:(void (^)())success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    //    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
    //                   dispatch_get_main_queue(), ^{
    //                       if (success) {
    //                           success();
    //                       }
    //                   });

    NSDictionary *params = @{
        @"api_token" : [ZPPUserManager sharedInstance].user.apiToken,
        @"order" : @{@"review" : comment}
    };

    NSString *urlString = [NSString stringWithFormat:@"orders/%@", orderID];

    [self.requestOperationManager PATCH:urlString
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            if (success) {
                success();
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

- (void)patchStarsWithValue:(NSNumber *)starValue
             forOrderWithID:(NSString *)orderID
                  onSuccess:(void (^)())success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *params = @{
        @"api_token" : [ZPPUserManager sharedInstance].user.apiToken,
        @"order" : @{@"rating" : starValue}
    };

    NSString *urlString = [NSString stringWithFormat:@"orders/%@", orderID];

    [self.requestOperationManager PATCH:urlString
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            if (success) {
                success();
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

@end
