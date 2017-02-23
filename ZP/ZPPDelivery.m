//
//  ZPPDelivery.m
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

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
