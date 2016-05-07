//
//  ZPPOrder.m
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrder.h"
#import "ZPPOrderItem.h"
#import "ZPPCreditCard.h"
#import "ZPPUser.h"
#import "ZPPUserManager.h"

@interface ZPPOrder ()

@property (strong, nonatomic) NSMutableArray *items;

@end

@implementation ZPPOrder

- (instancetype)init {
    self = [super init];
    if (self) {
        self.orderStatus = ZPPOrderStatusNotSended;
        self.deliverNow = YES;
    }
    return self;
}

- (instancetype)initWithIdentifier:(NSString *)identifier
                             items:(NSMutableArray *)items
                           address:(ZPPAddress *)address
                       orderStatus:(ZPPOrderStatus)status
                              date:(NSDate *)date
                            review:(NSString *)review
                            rating:(float)rating {
    self = [super init];
    if (self) {
        self.identifier = identifier;
        self.items = items;
        self.address = address;
        self.orderStatus = status;
        self.date = date;
        self.starValue = rating;
        self.commentString = review;
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
    for (int i = 0; i < self.items.count; i++) {
        ZPPOrderItem *orderItem = self.items[i];
        if (orderItem.count == 0) {
            [self.items removeObject:orderItem];
            i--;
        }
    }
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
    NSInteger price = 0;
    for (ZPPOrderItem *orderItem in self.items) {
        price += orderItem.count * [orderItem.item priceOfItem];
    }
    
    return price;
}

- (NSInteger)totalPriceWithDelivery {
    NSInteger price = [self totalPrice];
    
    if (price < 1000) {
        price += 200;
    }
    
    return price;
}

- (NSInteger)totalPriceWithAllTheThings {
    
    NSInteger price = [self totalPriceWithDelivery];
    ZPPUser *user = [ZPPUserManager sharedInstance].user;
    
    // Discount
    if ([user.discount intValue] != 0) {
        double discount = (double)price * ([user.discount doubleValue] / 100.0);
        price -= discount;
    }
    
    // Balance
    if ([user.balance intValue] > price) {
        price -= [user.balance intValue];
    } else {
        price -= [user.balance intValue];
    }
    
    // No zero  payments
    if (price <= 0) {
        price = 1;
    }
    
    return price;
}

- (BOOL)deliveryIncluded {
    return [self totalPrice] != [self totalPriceWithDelivery];
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
    self.orderStatus = ZPPOrderStatusNotSended;
}

@end
