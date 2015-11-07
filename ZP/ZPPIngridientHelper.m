//
//  ZPPIngridientHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPIngridientHelper.h"
#import "ZPPIngridient.h"
#import "ZPPServerManager.h"

NSString *const ZPPIngridientName = @"name";
NSString *const ZPPIngridientID = @"id";
NSString *const ZPPIngridientURL = @"image_url";

@implementation ZPPIngridientHelper

+ (ZPPIngridient *)ingridientFromDict:(NSDictionary *)dict {
    NSString *name = dict[ZPPIngridientName];
    NSString *ingridientID = dict[ZPPIngridientID];
    NSString *urlAppend = dict[ZPPIngridientURL];
    NSString *urlAsString = nil;
    if (![urlAppend isEqual:[NSNull null]]) {
        urlAsString = [ZPPServerBaseUrl stringByAppendingString:urlAppend];
    }

    return
        [[ZPPIngridient alloc] initWithName:name ingridientID:ingridientID urlAsString:urlAsString];
}

+ (NSArray *)parseIngridients:(NSArray *)ingridients {
    NSMutableArray *tmpArr = [NSMutableArray array];

    for (NSDictionary *d in ingridients) {
        ZPPIngridient *ingridient = [[self class] ingridientFromDict:d];
        [tmpArr addObject:ingridient];
    }
    return [NSArray arrayWithArray:tmpArr];
}

@end
