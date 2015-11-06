//
//  ZPPDishHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPDishHelper.h"
#import "ZPPDish.h"
#import "ZPPServerManager.h"
#import "ZPPIngridientHelper.h"

NSString *const ZPPDishName = @"name";
NSString *const ZPPDishID = @"id";
NSString *const ZPPDishDescription = @"description";
NSString *const ZPPDishPrice = @"price";
NSString *const ZPPDishImgURL = @"image_url";
NSString *const ZPPDishIngridients = @"ingredients";
NSString *const ZPPDishSubtitle = @"subtitle";

@implementation ZPPDishHelper

+ (ZPPDish *)dishFromDict:(NSDictionary *)dict {
    NSString *name = dict[ZPPDishName];
    NSString *dishID = dict[ZPPDishID];
    NSString *dishDescription = dict[ZPPDishDescription];
    NSString *subtitle = dict[ZPPDishSubtitle];
    NSNumber *dishPrice = dict[ZPPDishPrice];
    NSString *imgUrlAppend = dict[ZPPDishImgURL];
    NSString *dishImgURL = [ZPPServerBaseUrl stringByAppendingString:imgUrlAppend];
    NSArray *ingsTmp = dict[ZPPDishIngridients];
    NSArray *ingridients = [ZPPIngridientHelper parseIngridients:ingsTmp];

    ZPPDish *dish = [[ZPPDish alloc] initWithName:name
                                           dishID:dishID
                                         subtitle:subtitle
                                  dishDescription:dishDescription
                                            price:dishPrice
                                           imgURL:dishImgURL
                                      ingridients:ingridients];

    return dish;
}

+ (NSArray *)parseDishes:(NSArray *)dishes {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *d in dishes) {
        ZPPDish *dish = [[self class] dishFromDict:d];
        [tmpArr addObject:dish];
    }

    return [NSArray arrayWithArray:tmpArr];
}

//- (NSArray *)parseMeals:(NSArray *)meals {
//    NSMutableArray *tmpArr = [NSMutableArray array];
//    for (NSDictionary *d in dishes) {
//        ZPPDish *dish = [[self class] dishFromDict:d];
//        [tmpArr addObject:dish];
//    }
//
//    return [NSArray arrayWithArray:tmpArr];
//}

@end
