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
#import "ZPPUserManager.h"

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
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

- (void)PATCHUpdateUserWithName:(NSString *)name
                       lastName:(NSString *)lastName
                          email:(NSString *)email
                      onSuccess:(void (^)())success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    if (!name && !lastName && !email) {
        if (failure) {
            failure(nil, -1);
        }
        return;
    }

    NSMutableDictionary *userDict = [NSMutableDictionary dictionary];

    if (name) {
        userDict[@"first_name"] = name;
    }

    if (lastName) {
        userDict[@"last_name"] = lastName;
    }

    if (email) {
        userDict[@"email"] = email;
    }

    NSDictionary *params =
        @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken,
           @"user" : userDict };

    [self.requestOperationManager PATCH:@"user.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            DDLogInfo(@"update succes");
            if (success) {
                success();
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];

        }];
}

- (void)PATChPasswordOldPassword:(NSString *)oldPassword
                     newPassword:(NSString *)userNewPassword
                      completion:(void (^)(ZPPPasswordChangeStatus status,
                                           NSError *err,
                                           NSInteger stausCode))completion {
    // NSDictionary *params = @{ @"old_password" : oldPassword, @"new_password" : userNewPassword };

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       NSInteger st = arc4random() % 4;

                       completion(st, nil, 200);
                   });
}

// redo!
- (void)checkUserWithPhoneNumber:(NSString *)phoneNumber
                      completion:(void (^)(ZPPUserStatus status, NSError *err, NSInteger stausCode))
                                     completion {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{

                       if (completion) {
                           completion(arc4random() % 3, nil, 200);
                       }
                   });
}

- (void)renewPasswordWithNumber:(NSString *)number
                           code:(NSString *)code
                       password:(NSString *)password
                      onSuccess:(void (^)())success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (success) {
                           success();
                       }
                   });
}

- (void)getCurrentUserOnSuccess:(void (^)(ZPPUser *user))success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *params = @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken };

    [self.requestOperationManager GET:@"user.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSLog(@"resp %@", responseObject);

            ZPPUser *user = [ZPPUserHelper userFromDict:responseObject];

            if (success) {
                success(user);
            }

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSLog(@"err %@", error);
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

#pragma mark - new registration

- (void)sendSmsToPhoneNumber:(NSString *)phoneNumber
                   onSuccess:(void (^)(NSString *tempToken))success
                   onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
   // phoneNumber = [@"7" stringByAppendingString:phoneNumber];
    NSLog(@"phone number %@", phoneNumber);
    NSDictionary *params = @{ @"phone_number" : phoneNumber };

    [self.requestOperationManager POST:@"user/send_verification_code.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            NSLog(@"%@",responseObject);
            NSString *tempToken = @"";
            if (success) {
                success(tempToken);
            }

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

- (void)verifyPhoneNumber:(NSString *)phoneNumber
                     code:(NSString *)code
                    token:(NSString *)token
                onSuccess:(void (^)(ZPPUser *user))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    phoneNumber = [@"7" stringByAppendingString:phoneNumber];
    NSDictionary *params = @{ @"phone_number" : phoneNumber, @"sms_verification_code" : code };

    [self.requestOperationManager GET:@"user/verify_phone_number.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            
            
//            if()
            
            ZPPUser *user = [ZPPUserHelper userFromDict:responseObject];
            
            if(success ) {
                success(user);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

@end
