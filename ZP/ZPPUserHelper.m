//
//  ZPPUserHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPUserHelper.h"
#import "ZPPUser.h"

NSString * const ZPPFirstName = @"first_name";
NSString * const ZPPLastName = @"last_name";
NSString * const ZPPUserEmail = @"email";
NSString * const ZPPPhoneNumber = @"phone_number";
NSString * const ZPPAPIToken = @"api_token";
NSString * const ZPPUserID = @"id";
NSString * const ZPPUserPassword = @"password";
NSString * const ZPPUserPromocode = @"promo_code";
NSString * const ZPPUserBalance = @"balance";
         
NSString * const ZPPPromoCodeUsed = @"promo_used";
NSString * const ZPPPlatform = @"platform";
NSString * const ZPPAPNSToken = @"device_token";
         
@implementation ZPPUserHelper

+ (NSDictionary *)convertUser:(ZPPUser *)user {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];

    if (user.firstName) {
        d[ZPPFirstName] = user.firstName;
    }

    if (user.lastName) {
        d[ZPPLastName] = user.lastName;
    }

    if (user.email) {
        d[ZPPUserEmail] = user.email;
    }

    if (user.phoneNumber) {
        d[ZPPPhoneNumber] = user.phoneNumber;
    }

    if (user.userID) {
        d[ZPPUserID] = user.userID;
    }

    if (user.apiToken) {
        d[ZPPAPIToken] = user.apiToken;
    }
    
    if (user.pushToken) {
        d[ZPPAPNSToken] = user.pushToken;
    }
    
    if(user.platform) {
        d[ZPPPlatform] = user.platform;
    }

    return [NSDictionary dictionaryWithDictionary:d];
}

+ (ZPPUser *)userFromDict:(NSDictionary *)dict {  // redo implementation
    NSString *firstName;
    NSString *lastName;
    NSString *email;
    NSString *phoneNumber;
    NSString *userID;
    NSString *apiToken;
    NSString *promocode;
    BOOL promocodeUsed;
    NSString *balance;
    if (dict[ZPPAPIToken]) {
        apiToken = dict[ZPPAPIToken];
    }
    if (dict[ZPPFirstName]) {
        firstName = [dict objectForKey:ZPPFirstName];
    }
    if (dict[ZPPLastName]) {
        lastName = dict[ZPPLastName];
    }
    if (dict[ZPPUserEmail]) {
        email = [dict objectForKey:ZPPUserEmail];
    }

    if (dict[ZPPPhoneNumber]) {
        phoneNumber = dict[ZPPPhoneNumber];
    }

    if (dict[ZPPUserID]) {
        userID = dict[ZPPUserID];
    }

    if (dict[ZPPUserPromocode]) {
        promocode = dict[ZPPUserPromocode];
    }

    if (dict[ZPPUserBalance]) {
        balance = [dict[ZPPUserBalance] stringValue];
    }

    if (dict[ZPPPromoCodeUsed]) {
        promocodeUsed = [dict[ZPPPromoCodeUsed] boolValue];
    }
    ZPPUser *user = [[ZPPUser alloc] initWihtName:firstName
                                         lastName:lastName
                                            email:email
                                      phoneNumber:phoneNumber
                                           userID:userID
                                           apiKey:apiToken
                                        promocode:promocode
                                          balance:balance
                                        promoUsed:promocodeUsed];

    return user;
}

@end
