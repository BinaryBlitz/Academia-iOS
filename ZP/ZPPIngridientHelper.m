//
//  ZPPIngridientHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPIngridientHelper.h"
#import "ZPPIngridient.h"

#import "ZPPImageWorker.h"

NSString *const ZPPIngridientName = @"name";
NSString *const ZPPIngridientID = @"id";
NSString *const ZPPIngridientURL = @"image_url";
NSString *const ZPPIngridientWeight = @"weight";

@implementation ZPPIngridientHelper

+ (ZPPIngridient *)ingridientFromDict:(NSDictionary *)dict {
  NSString *name = dict[ZPPIngridientName];
  NSString *ingridientID = dict[ZPPIngridientID];
  NSString *urlAppend = dict[ZPPIngridientURL];
  NSString *urlAsString = nil;
  if (![urlAppend isEqual:[NSNull null]]) {
    urlAsString = urlAppend;
//        urlAsString = [ZPPServerBaseUrl stringByAppendingString:urlAppend];
  }

  NSNumber *weight;  // dict[ZPPIngridientWeight];

  if (dict[ZPPIngridientWeight] && ![dict[ZPPIngridientWeight] isEqual:[NSNull null]]) {
    weight = dict[ZPPIngridientWeight];
  }

  return [[ZPPIngridient alloc] initWithName:name
                                ingridientID:ingridientID
                                 urlAsString:urlAsString
                                      weight:weight];
}

+ (NSArray *)parseIngridients:(NSArray *)ingridients {
  NSMutableArray *tmpArr = [NSMutableArray array];

  for (NSDictionary *d in ingridients) {
    ZPPIngridient *ingridient = [[self class] ingridientFromDict:d];
    [tmpArr addObject:ingridient];
  }

  NSArray *res = [NSArray arrayWithArray:tmpArr];

  [ZPPImageWorker preheatImagesOfObjects:res];

  return res;
}

@end
