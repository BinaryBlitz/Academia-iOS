//
//  ZPPUser.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPUser : NSObject

@property (copy, nonatomic) NSString *firstName;//
@property (copy, nonatomic) NSString *lastName;//
@property (copy, nonatomic) NSString *email;//
@property (copy, nonatomic) NSString *phoneNumber;//
@property (copy, nonatomic) NSString *password;//
@property (copy, nonatomic) NSString *promoCode;
@property (copy, nonatomic) NSString *balance;
@property (assign, nonatomic) BOOL promoUsed;

@property (strong, nonatomic) NSString *pushToken;

@property (copy, nonatomic, readonly) NSString *apiToken;//
@property (copy, nonatomic, readonly) NSString *userID;//
@property (copy, nonatomic, readonly) NSString *platform;




//- (instancetype)initWithDict:(NSDictionary *)dict;

- (instancetype)initWihtName:(NSString *)name
                    lastName:(NSString *)lastName
                       email:(NSString *)email
                 phoneNumber:(NSString *)phoneNumber
                      userID:(NSString *)userID
                      apiKey:(NSString *)apiKey
                   promocode:(NSString *)promocode
                     balance:(NSString *)balance
                   promoUsed:(BOOL)promoUsed;

@end
