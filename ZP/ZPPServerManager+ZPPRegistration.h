//
//  ZPPServerManager+ZPPRegistration.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager.h"

typedef NS_ENUM(NSInteger, ZPPPasswordChangeStatus) {
    ZPPPasswordChangeStatusOldWrong,
    ZPPPasswordChangeStatusNewWrong,
    ZPPPasswordChangeStatusSuccess,
    ZPPPasswordChangeStatusUndefined
};

typedef NS_ENUM(NSInteger, ZPPUserStatus) {
    ZPPUserStatusExist,
    ZPPUserStatusNotExist,
    ZPPUserStatusUndefined
};

@class ZPPUser;
@interface ZPPServerManager (ZPPRegistration)

- (void)POSTRegistrateUser:(ZPPUser *)user
                 onSuccess:(void (^)(ZPPUser *user))success
                 onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)POSTAuthenticateUserWithEmail:(NSString *)email
                             password:(NSString *)password
                            onSuccess:(void (^)(ZPPUser *user))success
                            onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getCurrentUserOnSuccess:(void (^)(ZPPUser *user))success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getCurrentUserWithToken:(NSString *)token
                      onSuccess:(void (^)(ZPPUser *user))success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)PATCHUpdateUserWithName:(NSString *)name
                       lastName:(NSString *)lastName
                          email:(NSString *)email
                      onSuccess:(void (^)())success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)PATChPasswordOldPassword:(NSString *)oldPassword
                     newPassword:(NSString *)userNewPassword
                      completion:(void (^)(ZPPPasswordChangeStatus status,
                                           NSError *err,
                                           NSInteger stausCode))completion;

- (void)checkUserWithPhoneNumber:(NSString *)phoneNumber
                      completion:(void (^)(ZPPUserStatus status, NSError *err, NSInteger stausCode))
                                     completion;

- (void)renewPasswordWithNumber:(NSString *)number
                           code:(NSString *)code
                       password:(NSString *)password
                      onSuccess:(void (^)())success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

#pragma mark - new registration

- (void)sendSmsToPhoneNumber:(NSString *)phoneNumber
                   onSuccess:(void (^)(NSString *tempToken))success
                   onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)verifyPhoneNumber:(NSString *)phoneNumber
                     code:(NSString *)code
                    token:(NSString *)token
                onSuccess:(void (^)(NSString *token))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;


#pragma mark - push

- (void)updateToken:(NSString *)token onSuccess:(void (^)())success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
