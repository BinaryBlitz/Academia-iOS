//
//  ZPPCreditCard.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCreditCard.h"

@interface ZPPCreditCard ()

@property (strong, nonatomic) NSString *cardNumber;
@property (assign, nonatomic) NSInteger month;
@property (assign, nonatomic) NSInteger year;
@property (assign, nonatomic) NSInteger cvc;
@property (strong, nonatomic) NSString *bindID;

@end

@implementation ZPPCreditCard

- (instancetype)initWithCardNumber:(NSString *)cardNumber
                             month:(NSInteger)month
                              year:(NSInteger)year
                               cvc:(NSInteger)cvc {
    self = [super init];
    if (self) {
        self.cardNumber = cardNumber;
        self.month = month;
        self.year = year;
        self.cvc = cvc;
    }
    return self;
}

- (instancetype)initWithCardNumber:(NSString *)cardNumber
                             month:(NSInteger)month
                              year:(NSInteger)year
                            bindID:(NSString *)bindID {
    self = [super init];
    if (self) {
        self.cardNumber = cardNumber;
        self.month = month;
        self.year = year;
        self.bindID = bindID;
    }
    return self;
}

- (NSString *)formattedDate {
    NSString *prev = self.month < 10 ? @" " : @"";

    NSString *monthString = [NSString stringWithFormat:@"%@%@", prev, @(self.month)];

    NSString *yearString = [NSString stringWithFormat:@"%@", @(self.year % 2000)];

    return [NSString stringWithFormat:@"%@/%@", monthString, yearString];

    //  NSString *monthString = [NSString string
}

@end
