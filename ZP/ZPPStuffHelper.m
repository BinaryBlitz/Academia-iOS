//
//  ZPPStuffHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 06/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPStuffHelper.h"
#import "ZPPStuff.h"

#import "ZPPServerManager.h"

@implementation ZPPStuffHelper

+ (ZPPStuff *)stuffFromDict:(NSDictionary *)dict {
    NSString *name = dict[@"name"];
    // NSString *subtitle = dict[@"subtitle"];
    NSNumber *identifier = dict[@"id"];
    NSNumber *price = dict[@"price"];
    NSString *stuffDescription = dict[@"description"];
    NSString *urlAppend = dict[@"image_url"];

    NSString *urlAsString = [NSString stringWithFormat:@"%@%@", ZPPServerBaseUrl, urlAppend];
    NSURL *imgURL = [NSURL URLWithString:urlAsString];

    ZPPStuff *s = [[ZPPStuff alloc] initWithName:name
                                      identifier:identifier
                                           descr:stuffDescription
                                           price:price
                                          imgURL:imgURL];

    return s;
}

+ (NSArray *)parseStuff:(NSArray *)dishes {
    NSMutableArray *tmpArr = [NSMutableArray array];
    for (NSDictionary *d in dishes) {
        ZPPStuff *l = [[self class] stuffFromDict:d];
        [tmpArr addObject:l];
    }

    return [NSArray arrayWithArray:tmpArr];
}

@end
