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
#import "ZPPAddressHelper.h"
#import "ZPPDishHelper.h"
#import "ZPPDishHelper.h"

#import "NSDate+ZPPDateCategory.h"

@implementation ZPPOrderHelper

+ (NSDictionary *)orderDictFromOrder:(ZPPOrder *)order {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];

    dict[@"address"] = [order.address formatedDescr];
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (ZPPOrderItem *oi in order.items) {
        NSDictionary *d = @{ @"dish_id" : oi.item.identifierOfItem, @"quantity" : @(oi.count) };
        [tmpArr addObject:d];
    }
    dict[@"line_items_attributes"] = [NSArray arrayWithArray:tmpArr];
    dict[@"latitude"] = @(order.address.coordinate.latitude);
    dict[@"longitude"] = @(order.address.coordinate.longitude);
    
    if(order.date) {
        dict[@"scheduled_for"] = [order.date serverFormattedString];
    }

    NSLog(@"order dict %@", dict);

    return [NSDictionary dictionaryWithDictionary:dict];
}


//- (NSArray *)ordersArrFromDicts:(NSArray *)arr {
//    NSMutableArray *tmp = [NSMutableArray array];
//    for (NSDictionary *d in arr) {
//        
//        ZPPOrder *ord = [[self class] parseOrderFromDict:d];
//        
//        [tmp addObject:ord];
//        
//    }
//    
//    return [NSArray arrayWithArray:tmp];
//}

+ (ZPPOrder *)parseOrderFromDict:(NSDictionary *)dict {
    NSString *identifier = dict[@"id"];
    NSArray *lineAttributes = dict[@"line_items"];

    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in lineAttributes) {
        ZPPOrderItem *oi = [[self class] orderItemFromDict:d];
        [tmp addObject:oi];
    }
    
    NSString *dateString = dict[@"created_at"];
    
    NSDate *date = [NSDate customDateFromString:dateString];
    
    ZPPAddress *address = [ZPPAddressHelper addressFromDict:dict];
    ZPPOrderStatus status = [[self class] statusForString:dict[@"status"]];

    ZPPOrder *order = [[ZPPOrder alloc] initWithIdentifier:identifier
                                                     items:tmp
                                                   address:address
                                               orderStatus:status
                                                      date:date];

    return order;
}

+ (ZPPOrderStatus)statusForString:(NSString *)statusString {
    ZPPOrderStatus status = ZPPOrderStatusNew;
    if ([statusString isEqualToString:@"new"]) {
        status = ZPPOrderStatusNew;
    } else if ([statusString isEqualToString:@"rejected"]) {
        status = ZPPOrderStatusRejected;
    } else if ([statusString isEqualToString:@"delivered"]) {
        status = ZPPOrderStatusDelivered;
    } else if ([statusString isEqualToString:@"on_the_way"]) {
        status = ZPPOrderStatusOnTheWay;
    }

    return status;
}

+ (ZPPOrderItem *)orderItemFromDict:(NSDictionary *)dict {
    ZPPDish *d = [ZPPDishHelper dishFromDict:dict[@"dish"]];
    NSInteger count = [dict[@"quantity"] integerValue];

    ZPPOrderItem *oi = [[ZPPOrderItem alloc] initWithItem:d count:count];

    return oi;
}

//{
//    address = "Bolshaya Nikitskaya ul., 16";
//    "created_at" = "2015-11-28T09:48:47.629Z";
//    id = 1;
//    latitude = "55.7568535";
//    "line_items" =     (
//                        {
//                            dish =             {
//                                description = " vghv";
//                                id = 37;
//                                "image_url" =
//                                "/uploads/dish/image/37/28d4b09c85ff95e042700b3f44b96f25.jpg";
//                                name = "DIET MEAL";
//                                price = 490;
//                            };
//                            id = 1;
//                            quantity = 1;
//                        },
//                        {
//                            dish =             {
//                                description = "0434\U0430. ";
//                                id = 18;
//                                "image_url" =
//                                "/uploads/dish/image/18/9bc6b665b6a8e2c7cad2430cce3e3de8.jpg";
//                                name = "DIET MEAL";
//                                price = 430;
//                            };
//                            id = 2;
//                            quantity = 3;
//                        }
//                        );
//    longitude = "37.603995";
//    "scheduled_for" = "<null>";
//    status = new;
//    "total_price" = 1680;
//}

+ (NSArray *)parseOrdersFromDicts:(NSArray *)dicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in dicts) {
        
        ZPPOrder *ord = [[self class] parseOrderFromDict:d[@"order"]];
        
        [tmp addObject:ord];
        
    }
    
    return [NSArray arrayWithArray:tmp];
}

//+ (NSArray *)testOrders {
//    ZPPOrder *order = [[ZPPOrder alloc] init];
//    ZPPOrder *secondOrder = [[ZPPOrder alloc] init];
//    ZPPOrder *thirdOrder = [[ZPPOrder alloc] init];
//
//    ZPPDish *d1 = [[ZPPDish alloc] initWithName:@"Super meal"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(499)
//                                         imgURL:nil
//                                    ingridients:nil
//                                         badges:nil];
//    ZPPDish *d2 = [[ZPPDish alloc] initWithName:@"Diet meal"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(399)
//                                         imgURL:nil
//                                    ingridients:nil
//                                         badges:nil];
//    ZPPDish *d3 = [[ZPPDish alloc] initWithName:@"Hamburger"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(200)
//                                         imgURL:nil
//                                    ingridients:nil
//                                         badges:nil];
//    ZPPDish *d4 = [[ZPPDish alloc] initWithName:@"Salad"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(200)
//                                         imgURL:nil
//                                    ingridients:nil
//                                         badges:nil];
//
//    [order addItem:d1];
//    [order addItem:d1];
//    [order addItem:d4];
//    [order addItem:d2];
//
//    [secondOrder addItem:d4];
//    [secondOrder addItem:d1];
//    [secondOrder addItem:d3];
//    [secondOrder addItem:d3];
//
//    [thirdOrder addItem:d3];
//    [thirdOrder addItem:d2];
//    [thirdOrder addItem:d2];
//
//    return @[ order, secondOrder, thirdOrder ];
//}

@end
