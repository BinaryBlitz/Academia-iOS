//
//  ZPPServerManager+ZPPRegistration.m
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPRegistration.h"

@import AFNetworking;
#import "ZPPUserHelper.h"
#import "ZPPUserManager.h"

@implementation ZPPServerManager (ZPPRegistration)

- (void)POSTRegistrateUser:(ZPPUser *)user
                 onSuccess:(void (^)(ZPPUser *user))success
                 onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *userDict = [ZPPUserHelper convertUser:user];

    NSDictionary *params = @{ @"user" : userDict };
    [self.requestOperationManager POST:@"user.json"
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
            if (success) {
                success();
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            [[self class] failureWithBlock:failure error:error operation:operation];

        }];
}


- (void)updateToken:(nullable NSString *)token onSuccess:(void (^)())success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    
    NSDictionary *userDict = @{@"api_token": !token ? [NSNull null] : token,
                               @"platform":@"ios"};
    
    NSDictionary *params =
    @{ @"api_token" : [ZPPUserManager sharedInstance].user.apiToken,
       @"user" : userDict };
    
    [self.requestOperationManager PATCH:@"user.json"
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

- (void)PATChPasswordOldPassword:(NSString *)oldPassword
                     newPassword:(NSString *)userNewPassword
                      completion:(void (^)(ZPPPasswordChangeStatus status,
                                           NSError *err,
                                           NSInteger stausCode))completion {
    
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

    [self getCurrentUserWithToken:[ZPPUserManager sharedInstance].user.apiToken
                        onSuccess:success
                        onFailure:failure];
}

- (void)getCurrentUserWithToken:(NSString *)token
                      onSuccess:(void (^)(ZPPUser *user))success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    if (!token) {
        if (failure) {
            failure(nil, -1);
        }

        return;
    }

    NSDictionary *params = @{ @"api_token" : token };

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
    NSLog(@"phone number %@", phoneNumber);
    NSDictionary *params = @{ @"phone_number" : phoneNumber };

    [self.requestOperationManager POST:@"verification_tokens.json"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            NSLog(@"verf resp %@", responseObject);
            NSString *tempToken = responseObject[@"token"];
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
                onSuccess:(void (^)(NSString *token))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *params = @{ @"code" : code };

    NSString *urlString = [NSString stringWithFormat:@"verification_tokens/%@.json", token];

    [self.requestOperationManager PATCH:urlString
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSString *t = responseObject[@"api_token"];
            
            if([t isEqual:[NSNull null]]) {
                t = nil;
            }

            if (success) {
                success(t);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            [[self class] failureWithBlock:failure error:error operation:operation];
        }];
}

@end
