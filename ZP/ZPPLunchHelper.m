//
//  ZPPLunchHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 06/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPLunchHelper.h"
#import "ZPPLunch.h"
#import "ZPPServerManager.h"

#import "ZPPImageWorker.h"

@implementation ZPPLunchHelper

+ (ZPPLunch *)lunchFromDict:(NSDictionary *)dict {
    NSString *name = dict[@"name"];
    NSNumber *identifier = dict[@"id"];
    NSString *subtitle = dict[@"subtitle"];
    NSNumber *price = dict[@"price"];
    NSString *lunchDescription = dict[@"description"];
    NSString *urlAppend = dict[@"image_url"];

//    NSString *urlAsString = [NSString stringWithFormat:@"%@%@", ZPPServerBaseUrl, urlAppend];
    NSURL *imgURL = [NSURL URLWithString:urlAppend];

    ZPPLunch *l = [[ZPPLunch alloc] initWithName:name
                                      identifier:identifier
                                        subtitle:subtitle
                                           descr:lunchDescription
                                           price:price
                                          imgURL:imgURL];

    return l;
}

+ (NSArray *)parseLunches:(NSArray *)dishes {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *d in dishes) {
        ZPPLunch *l = [[self class] lunchFromDict:d];
        [tmpArr addObject:l];
    }
    

    NSArray *res = [NSArray arrayWithArray:tmpArr];
    
    [ZPPImageWorker preheatImagesOfObjects:res];

    return res;
}

@end
