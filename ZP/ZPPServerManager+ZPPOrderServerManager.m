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

            NSArray *orders = [ZPPOrderHelper parseOrdersFromDicts:responseObject];

            if (success) {
                success(orders);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];

        }];
}


- (void)POSTOrder:(ZPPOrder *)order {
    
}

@end
