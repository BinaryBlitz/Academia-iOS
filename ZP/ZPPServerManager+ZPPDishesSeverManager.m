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
#import "ZPPTimeManager.h"
#import "Academia-Swift.h"

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

            NSArray *dishes = [ZPPDishHelper parseDishes:responseObject];

            if (success) {
                success(dishes);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

- (void)getDayMenuOnSuccess:(void (^)(NSArray *meals, NSArray *dishes, NSArray *stuff, ZPPTimeManager *timeManager))success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {

    ZPPUser *user = [ZPPUserManager sharedInstance].user;
    NSString *token = user.apiToken;
    NSDictionary *params;
    if (token) {
        params = @{ @"api_token": [ZPPUserManager sharedInstance].user.apiToken };
    }

    [self.requestOperationManager GET:@"day.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSLog(@"%@",responseObject);
            [[ZPPTimeManager sharedManager] configureWithDict:responseObject];

            NSString *welcomeScreenImageURL = responseObject[@"welcome_screen_image_url"];
            if (![welcomeScreenImageURL isEqual: [NSNull null]]) {
                [[WelcomeScreenProvider sharedProvider] setImageURLString:welcomeScreenImageURL];
            } else {
                [[WelcomeScreenProvider sharedProvider] setImageURLString:nil];
            }

            ZPPTimeManager *timeManager = [ZPPTimeManager sharedManager];
            NSArray *lunchs = [ZPPDishHelper parseDishes:responseObject[@"lunches"]];
            NSArray *dishes = [ZPPDishHelper parseDishes:responseObject[@"dishes"]];
            NSArray *stuff = [ZPPStuffHelper parseStuff:responseObject[@"stuff"]];

            if(success) {
                success(lunchs, dishes, stuff, timeManager);
            }
        } failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

@end
