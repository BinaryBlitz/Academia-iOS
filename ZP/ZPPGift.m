//
//  ZPPGift.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPGift.h"

@interface ZPPGift ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *giftDescription;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *giftIdentifier;

@end

@implementation ZPPGift

- (instancetype)initWith:(NSString *)name
             description:(NSString *)giftDescription
                   price:(NSNumber *)price
              identifier:(NSNumber *)giftIdentifier {
    self = [super init];
    if (self) {
        self.name = name;
        self.giftDescription = giftDescription;
        self.price = price;
        self.giftIdentifier = giftIdentifier;
    }
    return self;
}

- (NSString *)nameOfItem {
    return self.name;
}

- (NSInteger)priceOfItem {
    return self.price.integerValue;
}

- (NSString *)identifierOfItem {
    return [NSString stringWithFormat:@"%@", self.giftIdentifier];
}

@end
