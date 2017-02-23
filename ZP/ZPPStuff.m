//
//  ZPPStuff.m
//  ZP
//
//  Created by Andrey Mikhaylov on 06/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPStuff.h"

@interface ZPPStuff ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *stufId;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSString *stuffDescr;
@property (strong, nonatomic) NSURL *imgURl;

@end

@implementation ZPPStuff

- (instancetype)initWithName:(NSString *)name
                  identifier:(NSNumber *)identifier
                       descr:(NSString *)descr
                       price:(NSNumber *)price
                      imgURL:(NSURL *)imgURL {
  self = [super init];
  if (self) {
    self.name = name;
    self.stufId = identifier;
    self.stuffDescr = descr;
    self.price = price;
    self.imgURl = imgURL;
  }
  return self;
}

- (NSString *)nameOfItem {
  return self.name;
}

- (NSInteger)priceOfItem {
  return self.price.integerValue;
}

- (NSString *)identifierOfItem {
  return [NSString stringWithFormat:@"%@", self.stufId];
}

- (NSURL *)URLOfImage {
  return self.imgURl;
}

@end
