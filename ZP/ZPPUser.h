//
//  ZPPUser.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import Foundation;

@interface ZPPUser : NSObject

@property (copy, nonatomic, nullable) NSString *firstName;
@property (copy, nonatomic, nullable) NSString *lastName;
@property (copy, nonatomic, nullable) NSString *email;
@property (copy, nonatomic, nullable) NSString *phoneNumber;
@property (copy, nonatomic, nullable) NSString *password;
@property (copy, nonatomic, nullable) NSString *promoCode;
@property (copy, nonatomic, nullable) NSString *balance;
@property (copy, nonatomic, nullable) NSString *discount;
@property (assign, nonatomic) BOOL promoUsed;

@property (strong, nonatomic, nullable) NSString *pushToken;

@property (copy, nonatomic, readonly, nullable) NSString *apiToken;
@property (copy, nonatomic, readonly, nullable) NSString *userID;
@property (copy, nonatomic, readonly, nullable) NSString *platform;

- (nonnull instancetype)initWihtName:(nullable NSString *)name
                            lastName:(nullable NSString *)lastName
                               email:(nullable NSString *)email
                         phoneNumber:(nullable NSString *)phoneNumber
                              userID:(nullable NSString *)userID
                              apiKey:(nullable NSString *)apiKey
                           promocode:(nullable NSString *)promocode
                             balance:(nullable NSString *)balance
                            discount:(nullable NSString *)discount
                           promoUsed:(BOOL)promoUsed;

@end
