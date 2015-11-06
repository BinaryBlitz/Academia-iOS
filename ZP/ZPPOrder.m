//
//  ZPPOrder.m
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrder.h"
#import "ZPPOrderItem.h"

@interface ZPPOrder ()

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation ZPPOrder

//- (instancetype)init {
//    self = [super init];
//    if (self) {
//
//    }
//    return self;
//}

- (void)addItem:(id<ZPPItemProtocol>)item {
    ZPPOrderItem *oi = [self orderItemForItem:item];
    if (oi) {
        [oi addOneItem];
    } else {
        oi = [[ZPPOrderItem alloc] initWithItem:item];
        [self.items addObject:oi];
    }
}

- (void)removeItem:(id<ZPPItemProtocol>)item {
    ZPPOrderItem *oi = [self orderItemForItem:item];

    if (oi) {
        [oi removeOneItem];
        if (oi.count == 0) {
            [self.items removeObject:oi];
        }
    }
}

- (void)checkAllAndRemoveEmpty {
    for(ZPPOrderItem *order in self.items) {
        if(order.count == 0) {
            [self.items removeObject:order];
        }
    }
}

- (ZPPOrderItem *)orderItemForItem:(id<ZPPItemProtocol>)item {
    for (ZPPOrderItem *oi in self.items) {
        if ([oi.item isEqual:item]) {
            return oi;
        }
    }
    return nil;
}

- (NSInteger)totalCount {
    NSInteger res = 0;
    for(ZPPOrderItem *oi in self.items) {
        res+=oi.count;
    }
    return res;
}

- (NSInteger)totalPrice {
    NSInteger res = 0;
    for(ZPPOrderItem *oi in self.items) {
        res+=oi.count * [oi.item priceOfItem];
    }
    return res;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

@end
