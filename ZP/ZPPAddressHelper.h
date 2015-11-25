//
//  ZPPAdressHelper.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPPAddress;
@class LMAddress;
@interface ZPPAddressHelper : NSObject

+ (ZPPAddress *)addresFromAddres:(LMAddress *)addr;


+ (NSArray *)addressesFromFoursquareDict:(id)responseObject;
+ (NSArray *)addressesFromDaDataDicts:(NSArray *)dicts;

@end
