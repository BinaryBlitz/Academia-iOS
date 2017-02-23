//
//  ZPPAdressHelper.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import Foundation;

@class ZPPAddress;
@class LMAddress;

@interface ZPPAddressHelper : NSObject

+ (ZPPAddress *)addresFromAddres:(LMAddress *)addr;
+ (ZPPAddress *)addressFromDict:(NSDictionary *)dict;
+ (NSArray *)addressesFromDaDataDicts:(NSArray *)dicts;

+ (NSArray *)parsePoints:(NSArray *)points;


@end
