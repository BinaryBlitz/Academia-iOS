//
//  ZPPCreditCard.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCreditCard.h"
#import "NSDate+ZPPDateCategory.h"

@interface ZPPCreditCard()

@property (assign, nonatomic) NSInteger serverId;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *bindingId;
@property (strong, nonatomic) NSDate *createdAt;

@end

@implementation ZPPCreditCard

+ (ZPPCreditCard *)initWithDictionary: (NSDictionary *)dict {
    NSNumber *serverId = dict[@"id"];
    NSString *cardNumber = dict[@"number"];
    NSString *bindingId = dict[@"binding_id"];
    NSString *dateString = dict[@"created_at"];
    
    ZPPCreditCard *card = [[ZPPCreditCard alloc] initWithCardNumber:cardNumber serverId:serverId.integerValue bindingId:bindingId createdAt:[NSDate customDateFromString:dateString]];
    return card;
}

- (instancetype)initWithCardNumber:(NSString *)cardNumber serverId:(NSInteger)serverId bindingId:(NSString *) bindingId createdAt:(NSDate *)createdAt {
    self = [super init];
    if (self) {
        self.serverId = serverId;
        self.number = cardNumber;
        self.bindingId = bindingId;
        self.createdAt = createdAt;
    }
    
    return self;
}

@end
