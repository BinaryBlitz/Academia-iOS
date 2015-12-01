//
//  ZPPOrderHelper.h
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPPOrder;
@interface ZPPOrderHelper : NSObject

+ (NSArray *)parseOrdersFromDicts:(NSArray *)dicts;
+ (NSDictionary *)orderDictFromOrder:(ZPPOrder *)order;

+ (ZPPOrder *)parseOrderFromDict:(NSDictionary *)dict;

//- (NSArray *)ordersArrFromDicts:(NSArray *)arr;

@end
