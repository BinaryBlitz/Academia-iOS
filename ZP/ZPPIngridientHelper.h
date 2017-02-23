//
//  ZPPIngridientHelper.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPPIngridient;

@interface ZPPIngridientHelper : NSObject

//+ (ZPPIngridient *)ingridientFromDict:(NSDictionary *)dict ;
+ (NSArray *)parseIngridients:(NSArray *)ingridients;

@end
