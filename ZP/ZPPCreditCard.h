//
//  ZPPCreditCard.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import Foundation;

@interface ZPPCreditCard : NSObject

@property (assign, nonatomic, readonly) NSInteger serverId;
@property (strong, nonatomic, readonly) NSString *number;
@property (strong, nonatomic, readonly) NSString *bindingId;
@property (strong, nonatomic, readonly) NSDate *createdAt;

+ (ZPPCreditCard *)initWithDictionary:(NSDictionary *)dict;

- (instancetype)initWithCardNumber:(NSString *)cardNumber serverId:(NSInteger)serverId bindingId:(NSString *)bindingId createdAt:(NSDate *)createdAt;

@end
