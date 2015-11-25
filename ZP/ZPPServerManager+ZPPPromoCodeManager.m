//
//  ZPPServerManager+ZPPPromoCodeManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPPromoCodeManager.h"
#import "ZPPUserManager.h"
#import "AFNetworking.h"

NSString *const ZPPWrongCardNumber = @"Неправильный код, попробуйте еще раз";

@implementation ZPPServerManager (ZPPPromoCodeManager)

- (void)POSTPromocCode:(NSString *)code
             onSuccess:(void (^)())success
             onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {//redo
    if (!code) {
        if (failure) {
            failure(nil, -1);
        }
    }

    NSDictionary *params =
        @{ @"code" : code,
           @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };

    [self.requestOperationManager POST:@"promo_codes/redeem.json"
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
