//
//  QZBUser.m
//  QZBQuizBattle
//
//  Created by Andrey Mikhaylov on 13/12/14.
//  Copyright (c) 2014 Andrey Mikhaylov. All rights reserved.
//

#import "ZPPUser.h"
#import "ZPPUserHelper.h"

@interface ZPPUser ()

@property (copy, nonatomic) NSString *apiToken;
@property (copy, nonatomic) NSString *userID;

@end

@implementation ZPPUser

- (NSString *)platform {
  return @"ios";
}

- (instancetype)initWihtName:(NSString *)name
                    lastName:(NSString *)lastName
                       email:(NSString *)email
                 phoneNumber:(NSString *)phoneNumber
                      userID:(NSString *)userID
                      apiKey:(NSString *)apiKey
                   promocode:(NSString *)promocode
                     balance:(NSString *)balance
                    discount:(NSString *)discount
                   promoUsed:(BOOL)promoUsed {
  self = [super init];
  if (self) {
    self.firstName = name;
    self.lastName = lastName;
    self.email = email;
    self.phoneNumber = phoneNumber;
    self.userID = userID;
    self.apiToken = apiKey;
    self.promoCode = promocode;
    self.balance = balance;
    self.discount = discount;
    self.promoUsed = promoUsed;
  }
  return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
  self = [[ZPPUser alloc] init];
  if (self) {
    self.firstName = [coder decodeObjectForKey:ZPPFirstName];
    self.lastName = [coder decodeObjectForKey:ZPPLastName];
    self.email = [coder decodeObjectForKey:ZPPUserEmail];
    self.apiToken = [coder decodeObjectForKey:ZPPAPIToken];
    self.phoneNumber = [coder decodeObjectForKey:ZPPPhoneNumber];
    self.userID = [coder decodeObjectForKey:ZPPUserID];
    self.promoCode = [coder decodeObjectForKey:ZPPUserPromocode];

    self.balance = [coder decodeObjectForKey:ZPPUserBalance];

    if ([coder decodeObjectForKey:ZPPUserDiscount]) {
      self.discount = [coder decodeObjectForKey:ZPPUserDiscount];
    } else {
      self.discount = @"0";
    }
  }
  return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
  [coder encodeObject:self.firstName forKey:ZPPFirstName];
  [coder encodeObject:self.lastName forKey:ZPPLastName];
  [coder encodeObject:self.email forKey:ZPPUserEmail];
  [coder encodeObject:self.apiToken forKey:ZPPAPIToken];
  [coder encodeObject:self.phoneNumber forKey:ZPPPhoneNumber];
  [coder encodeObject:self.userID forKey:ZPPUserID];
  [coder encodeObject:self.promoCode forKey:ZPPUserPromocode];

  [coder encodeObject:self.balance forKey:ZPPUserBalance];
  [coder encodeObject:self.discount forKey:ZPPUserDiscount];
}

@end
