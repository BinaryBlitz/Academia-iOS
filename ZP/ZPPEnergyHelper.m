#import "ZPPEnergyHelper.h"
#import "ZPPEnergy.h"

@implementation ZPPEnergyHelper

+ (ZPPEnergy *)parseEnergyDict:(NSDictionary *)energyDict {
  //    @property (strong, nonatomic, readonly) NSNumber *fats;
  //    @property (strong, nonatomic, readonly) NSNumber *kilocalories;
  //    @property (strong, nonatomic, readonly) NSNumber *carbohydrates;
  //    @property (strong, nonatomic, readonly) NSNumber *proteins;

  NSNumber *fats = [[self class] checkNum:energyDict[@"fats"]];
  NSNumber *kilocalories = [[self class] checkNum:energyDict[@"calories"]];
  NSNumber *carbohydrates = [[self class] checkNum:energyDict[@"carbohydrates"]];
  NSNumber *proteins = [[self class] checkNum:energyDict[@"proteins"]];

  ZPPEnergy *energy;
  if (fats && kilocalories && carbohydrates && proteins) {
    energy = [[ZPPEnergy alloc] initWithFats:fats
                                kilocalories:kilocalories
                               carbohydrates:carbohydrates
                                    proteins:proteins];
  }

  return energy;
}

+ (NSNumber *)checkNum:(NSNumber *)number {
  if (number && ![number isEqual:[NSNull null]] && [number isKindOfClass:[NSNumber class]]) {
    return number;
  } else {
    return nil;
  }
}

+ (ZPPEnergy *)testEnergy {
  ZPPEnergy *e =
      [[ZPPEnergy alloc] initWithFats:@(10) kilocalories:@(500) carbohydrates:@(5) proteins:@(2)];
  return e;
}
@end
