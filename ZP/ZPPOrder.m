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

- (instancetype)initWithIdentifier:(NSString *)identifier
                             items:(NSMutableArray *)items
                           address:(ZPPAddress *)address
                       orderStatus:(ZPPOrderStatus)status
                              date:(NSDate *)date {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.items = items;
        self.address = address;
        self.orderStatus = status;
        self.date = date;
    }
    return self;
}

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
    //   NSMutableArray *tmpArr = [NSMutableArray array];

    for (int i = 0; i < self.items.count; i++) {
        ZPPOrderItem *orderItem = self.items[i];
        if (orderItem.count == 0) {
            [self.items removeObject:orderItem];
            i--;
        }
    }

    //    for(ZPPOrderItem *orderItem in self.items) {
    //        if(orderItem.count == 0) {
    //            [tmpArr addObject:orderItem];
    //        }
    //    }
    //    for(ZPPOrderItem *oredrItem in tmpArr) {
    //        [self.items removeObject:oredrItem];
    //    }
}

- (ZPPOrderItem *)orderItemForItem:(id<ZPPItemProtocol>)item {
    for (ZPPOrderItem *oi in self.items) {
        if ([[oi.item identifierOfItem] isEqual:[item identifierOfItem]]) {
            return oi;
        }
    }
    return nil;
}

- (NSInteger)totalCount {
    NSInteger res = 0;
    for (ZPPOrderItem *oi in self.items) {
        res += oi.count;
    }
    return res;
}

- (NSInteger)totalPrice {
    NSInteger res = 0;
    for (ZPPOrderItem *oi in self.items) {
        res += oi.count * [oi.item priceOfItem];
    }
    return res;
}

- (NSMutableArray *)items {
    if (!_items) {
        _items = [NSMutableArray array];
    }
    return _items;
}

- (NSString *)orderDescr {
    NSString *descrString = @"";
    for (ZPPOrderItem *item in self.items) {
        NSString *str = [item.item nameOfItem];
        if (descrString.length != 0) {
            str = [@", " stringByAppendingString:str];
        } else {
            str = [str capitalizedString];
        }
        descrString = [descrString stringByAppendingString:str];
    }

    return descrString;
}


- (void)clearOrder {
    self.items = nil;
    self.identifier = nil;
    self.address = nil;
    self.date = nil;
}

@end
