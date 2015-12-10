//
//  ZPPEnergyHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 10/12/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPEnergyHelper.h"
#import "ZPPEnergy.h"

@implementation ZPPEnergyHelper

+ (ZPPEnergy *)parseEnergyDict:(NSDictionary *)energyDict {
    return [[self class] testEnergy];
}

+ (ZPPEnergy *)testEnergy {
    ZPPEnergy *e = [[ZPPEnergy alloc] initWithFats:@(10) kilocalories:@(500) carbohydrates:@(5) proteins:@(2)];
    return e;
}
@end
