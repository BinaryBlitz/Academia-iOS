//
//  ZPPOrderHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderHelper.h"
#import "ZPPOrder.h"
#import "ZPPDish.h"
#import "ZPPAddress.h"
#import "ZPPOrderItem.h"

@implementation ZPPOrderHelper

+ (NSDictionary *)orderDictFromDict:(ZPPOrder *)order {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"address"] = [order.address formatedDescr];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (ZPPOrderItem *oi in order.items) {
        NSDictionary *d = @{ @"dish_id" : oi.item.identifierOfItem, @"quantity" : @(oi.count) };
        [tmpArr addObject:d];
    }
    dict[@"line_items_attributes"] = [NSArray arrayWithArray:tmpArr];

    return [NSDictionary dictionaryWithDictionary:dict];
}

+ (NSArray *)parseOrdersFromDicts:(NSArray *)dicts {
    return [[self class] testOrders];
}

+ (NSArray *)testOrders {
    ZPPOrder *order = [[ZPPOrder alloc] init];
    ZPPOrder *secondOrder = [[ZPPOrder alloc] init];
    ZPPOrder *thirdOrder = [[ZPPOrder alloc] init];

    ZPPDish *d1 = [[ZPPDish alloc] initWithName:@"Super meal"
                                         dishID:nil
                                       subtitle:nil
                                dishDescription:nil
                                          price:@(499)
                                         imgURL:nil
                                    ingridients:nil];
    ZPPDish *d2 = [[ZPPDish alloc] initWithName:@"Diet meal"
                                         dishID:nil
                                       subtitle:nil
                                dishDescription:nil
                                          price:@(399)
                                         imgURL:nil
                                    ingridients:nil];
    ZPPDish *d3 = [[ZPPDish alloc] initWithName:@"Hamburger"
                                         dishID:nil
                                       subtitle:nil
                                dishDescription:nil
                                          price:@(200)
                                         imgURL:nil
                                    ingridients:nil];
    ZPPDish *d4 = [[ZPPDish alloc] initWithName:@"Salad"
                                         dishID:nil
                                       subtitle:nil
                                dishDescription:nil
                                          price:@(200)
                                         imgURL:nil
                                    ingridients:nil];

    [order addItem:d1];
    [order addItem:d1];
    [order addItem:d4];
    [order addItem:d2];

    [secondOrder addItem:d4];
    [secondOrder addItem:d1];
    [secondOrder addItem:d3];
    [secondOrder addItem:d3];

    [thirdOrder addItem:d3];
    [thirdOrder addItem:d2];
    [thirdOrder addItem:d2];

    return @[ order, secondOrder, thirdOrder ];
}


@end
