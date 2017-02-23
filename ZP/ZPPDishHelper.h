//
//  ZPPDishHelper.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPPDish;

@interface ZPPDishHelper : NSObject

+ (NSArray *)parseDishes:(NSArray *)dishes;
+ (ZPPDish *)dishFromDict:(NSDictionary *)dict;


@end
