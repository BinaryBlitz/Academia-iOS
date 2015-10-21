//
//  ZPPUserHelper.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString const*ZPPFirstName;// = @"first_name";
extern NSString const*ZPPLastName ;//= @"last_name";
extern NSString const*ZPPUserEmail;// = @"email";
extern NSString const*ZPPPhoneNumber;// = @"phone_number";
extern NSString const*ZPPAPIToken;// = @"api_token";
extern NSString const*ZPPUserID;// = @"id";
extern NSString const*ZPPUserPassword;

@class ZPPUser;

@interface ZPPUserHelper : NSObject

+ (NSDictionary *)convertUser:(ZPPUser *)user;
+ (ZPPUser *)userFromDict:(NSDictionary *)dict;

@end
