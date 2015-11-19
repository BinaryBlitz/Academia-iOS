//
//  ZPPServerManager+ZPPDishesSeverManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPDishesSeverManager.h"
#import "AFNetworking.h"
#import "ZPPUserManager.h"
#import "ZPPDishHelper.h"
#import "ZPPLunchHelper.h"
#import "ZPPStuffHelper.h"

@implementation ZPPServerManager (ZPPDishesSeverManager)

- (void)GETDishesOnSuccesOnSuccess:(void (^)(NSArray *dishes))success
                         onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    ZPPUser *user = [ZPPUserManager sharedInstance].user;
    if (!user.apiToken) {
        if (failure) {
            failure(nil, 422);
        }
        return;
    }
    NSDictionary *params = @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };

    [self.requestOperationManager GET:@"dishes.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

         //   DDLogInfo(@"dishes %@", responseObject);
            
            
            NSArray *dishes = [ZPPDishHelper parseDishes:responseObject];
          //  NSArray *lunches = [ZPPLunchHelper parseLunches:<#(NSArray *)#>]

            if (success) {
                success(dishes);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

- (void)getDayMenuOnSuccess:(void (^)(NSArray *meals, NSArray *dishes, NSArray *stuff))success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    ZPPUser *user = [ZPPUserManager sharedInstance].user;
    if (!user.apiToken) {
        if (failure) {
            failure(nil, 422);
        }
        return;
    }
    NSDictionary *params = @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };

    [self.requestOperationManager GET:@"day.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            NSLog(@"%@",responseObject);
            NSArray *lunchs = [ZPPLunchHelper parseLunches:responseObject[@"lunches"]];
            NSArray *dishes = [ZPPDishHelper parseDishes:responseObject[@"dishes"]];
            NSArray *stuffs = [ZPPStuffHelper parseStuff:responseObject[@"stuff"]];
//            NSArray *stuff = responseObject[@"dishes"];
//            NSMutableArray *lunchTMP = [NSMutableArray array];
//            NSMutableArray *dishesTMP = [NSMutableArray array];
//            NSMutableArray *stuffTMP = [NSMutableArray array];
            
            if(success) {
                success(lunchs,dishes, stuffs);
            }
            
            
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];

        }];
}




@end
