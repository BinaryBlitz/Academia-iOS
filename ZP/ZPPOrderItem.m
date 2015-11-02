//
//  ZPPOrderItem.m
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderItem.h"

@interface ZPPOrderItem ()

@property (strong, nonatomic) id<ZPPItemProtocol> item;
@property (assign, nonatomic) NSInteger count;

@end

@implementation ZPPOrderItem

- (instancetype)initWithItem:(id<ZPPItemProtocol>)item {
    self = [super init];
    if (self) {
        self.item = item;
        self.count = 1;
    }
    return self;
}

- (void)addOneItem {
    self.count++;
}

- (void)removeOneItem {
    if (self.count > 0) {
        self.count--;
    }
}

- (NSInteger)totalPrice {
    return self.count * [self.item priceOfItem];
}

@end
