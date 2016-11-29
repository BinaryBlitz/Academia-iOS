//
//  ZPPDishHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPBadgeHelper.h"
#import "ZPPDish.h"
#import "ZPPDishHelper.h"
#import "ZPPEnergy.h"
#import "ZPPEnergyHelper.h"
#import "ZPPIngridientHelper.h"
#import "ZPPServerManager.h"

#import "ZPPImageWorker.h"

NSString *const ZPPDishName = @"name";
NSString *const ZPPDishID = @"id";
NSString *const ZPPDishDescription = @"description";
NSString *const ZPPDishPrice = @"price";
NSString *const ZPPDishImgURL = @"image_url";
NSString *const ZPPDishIngridients = @"ingredients";
NSString *const ZPPDishSubtitle = @"subtitle";
NSString *const ZPPDishBadges = @"badges";
NSString *const ZPPOutOfStock = @"out_of_stock";

@implementation ZPPDishHelper

+ (ZPPDish *)dishFromDict:(NSDictionary *)dict {
    NSString *name = dict[ZPPDishName];
    NSString *dishID = dict[ZPPDishID];
    NSString *dishDescription = dict[ZPPDishDescription];
    NSString *subtitle = dict[ZPPDishSubtitle];
    NSNumber *dishPrice = dict[ZPPDishPrice];
    NSString *imgUrlAppend = dict[ZPPDishImgURL];
    NSNumber *outOfStockNum = dict[ZPPOutOfStock];
    
    BOOL outOfStock = NO;
    
    if (outOfStockNum && [outOfStockNum isKindOfClass:[NSNumber class]]) {
        outOfStock = outOfStockNum.boolValue;
    }
    
    NSString *dishImgURL;
    if (imgUrlAppend && ![imgUrlAppend isEqual:[NSNull null]]) {
        dishImgURL = imgUrlAppend;
//        dishImgURL = [ZPPServerBaseUrl stringByAppendingString:imgUrlAppend];
    }
    // NSString *dishImgURL = [ZPPServerBaseUrl stringByAppendingString:imgUrlAppend];
    NSArray *ingsTmp = dict[ZPPDishIngridients];
    NSArray *ingridients = [ZPPIngridientHelper parseIngridients:ingsTmp];
    NSArray *badgesDicts = dict[ZPPDishBadges];
    NSArray *badges = [ZPPBadgeHelper parseBadgeArray:badgesDicts];

    ZPPEnergy *energy = [ZPPEnergyHelper parseEnergyDict:dict];

    ZPPDish *dish = [[ZPPDish alloc] initWithName:name
                                           dishID:dishID
                                         subtitle:subtitle
                                  dishDescription:dishDescription
                                            price:dishPrice
                                           imgURL:dishImgURL
                                      ingridients:ingridients
                                           badges:badges
                                          noItems:outOfStock
                                           energy:energy];

    return dish;
}

+ (NSArray *)parseDishes:(NSArray *)dishes {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *d in dishes) {
        ZPPDish *dish = [[self class] dishFromDict:d];
        [tmpArr addObject:dish];
    }

    NSArray *res = [NSArray arrayWithArray:tmpArr];

    [ZPPImageWorker preheatImagesOfObjects:res];

    return res;
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
