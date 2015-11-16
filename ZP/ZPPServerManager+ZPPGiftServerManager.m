//
//  ZPPServerManager+ZPPGiftServerManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPGiftServerManager.h"
#import "ZPPUserManager.h"
#import "ZPPGiftHelper.h"
#import "AFNetworking.h"

@implementation ZPPServerManager (ZPPGiftServerManager)

- (void)GETGiftsOnSuccess:(void (^)(NSArray *gifts))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {//redo test
    NSDictionary *params = @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (success) {
                           success([ZPPGiftHelper parseGiftFromDicts:nil]);
                       }
                   });

    //    [self.requestOperationManager GET:@"gifts"
    //        parameters:params
    //        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
    //
    //            NSArray *arr = [ZPPGiftHelper parseGiftFromDicts:responseObject];
    //            if(success){
    //                success(arr);
    //            }
    //        }
    //        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error){
    //
    //            [[self class] failureWithBlock:failure error:error operation:operation];
    //        }];
}

@end
