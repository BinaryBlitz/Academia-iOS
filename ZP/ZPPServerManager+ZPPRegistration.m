//
//  ZPPServerManager+ZPPRegistration.m
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPRegistration.h"
#import <AFNetworking.h>
#import "ZPPUserHelper.h"

//#import <CocoaLumberjack.h>

// static const int ddLogLevel = DDLogLevelDebug;

@implementation ZPPServerManager (ZPPRegistration)

- (void)POSTRegistrateUser:(ZPPUser *)user
                 onSuccess:(void (^)(ZPPUser *user))success
                 onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *userDict = [ZPPUserHelper convertUser:user];

    NSDictionary *params = @{ @"user" : userDict };
    [self.requestOperationManager POST:@"user.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            DDLogInfo(@"user registration response %@", responseObject);
            ZPPUser *user = [ZPPUserHelper userFromDict:responseObject];
            if (success) {
                success(user);
            }

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

- (void)POSTAuthenticateUserWithEmail:(NSString *)email
                             password:(NSString *)password
                            onSuccess:(void (^)(ZPPUser *user))success
                            onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    if (!email || !password) {
        if (failure) {
            failure(nil, -1);
        }
        return;
    }

    //    "email": "foo@bar.com",
    //    "password": "foobar"
    NSDictionary *params = @{ @"email" : email, @"password" : password };

    [self.requestOperationManager POST:@"user/authenticate.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            ZPPUser *user = [ZPPUserHelper userFromDict:responseObject];

            if (success) {
                success(user);
            }

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error){

        }];
}

@end
