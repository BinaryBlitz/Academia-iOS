//
//  ZPPCategoryHelper.m
//  Academia
//
//  Created by Алексей on 04.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPCategoryHelper.h"
#import "ZPPCategory.h"

@implementation ZPPCategoryHelper
+ (NSArray *)parseCategories:(NSArray *)array {

  NSMutableArray *tmpArr = [NSMutableArray array];
  for (NSDictionary *dict in array) {
    NSString *name = dict[@"name"];
    NSNumber *identifier = dict[@"id"];
    ZPPCategory *category = [[ZPPCategory alloc] initWithIdentificator:identifier name:name];
    [tmpArr addObject:category];
  }
  return [NSArray arrayWithArray:tmpArr];
}


@end
