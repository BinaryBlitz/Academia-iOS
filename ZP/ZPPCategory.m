//
//  ZPPCategory.m
//  Academia
//
//  Created by Алексей on 03.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPCategory.h"

@implementation ZPPCategory
- (instancetype)initWithIdentificator:(NSNumber *)identificator
                                 name:(NSString *)name {
  self._id = identificator;
  self.name = name;

  return self;
}

@end
