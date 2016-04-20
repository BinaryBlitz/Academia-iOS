//
//  ZPPCreditCard.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCreditCard.h"

@interface ZPPCreditCard()

@property (assign, nonatomic) NSInteger serverId;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *bindingId;

@end

@implementation ZPPCreditCard

+ (ZPPCreditCard *)initWithDictionary: (NSDictionary *)dict {
    NSNumber *serverId = dict[@"id"];
    NSString *cardNumber = dict[@"number"];
    NSString *bindingId = dict[@"binding_id"];
    
    ZPPCreditCard *card = [[ZPPCreditCard alloc] initWithCardNumber:cardNumber serverId:serverId.integerValue bindingId:bindingId];
    return card;
}

- (instancetype)initWithCardNumber:(NSString *)cardNumber serverId:(NSInteger)serverId bindingId:(NSString *) bindingId {
    self = [super init];
    if (self) {
        self.serverId = serverId;
        self.number = cardNumber;
        self.bindingId = bindingId;
    }
    
    return self;
}

@end
