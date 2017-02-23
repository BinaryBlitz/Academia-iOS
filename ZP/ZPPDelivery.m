#import "ZPPDelivery.h"

@implementation ZPPDelivery

- (NSString *)nameOfItem {
  return @"Доставка";
}

- (NSInteger)priceOfItem {
  return 250;
}

- (NSString *)identifierOfItem {
  return [NSString stringWithFormat:@"-1"];
}

@end
