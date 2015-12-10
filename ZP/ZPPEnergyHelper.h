//
//  ZPPEnergyHelper.h
//  ZP
//
//  Created by Andrey Mikhaylov on 10/12/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPPEnergy;

@interface ZPPEnergyHelper : NSObject

+ (ZPPEnergy *)parseEnergyDict:(NSDictionary *)energyDict;

@end
