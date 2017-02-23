#import <Foundation/Foundation.h>

@class ZPPEnergy;

@interface ZPPEnergyHelper : NSObject

+ (ZPPEnergy *)parseEnergyDict:(NSDictionary *)energyDict;

@end
