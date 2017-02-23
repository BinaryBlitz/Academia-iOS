//
//  ZPPDish.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPDish.h"
#import "ZPPEnergy.h"

@interface ZPPDish ()

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *dishID;
@property (copy, nonatomic) NSString *dishDescription;
@property (copy, nonatomic) NSNumber *price;
@property (copy, nonatomic) NSString *urlAsString;
@property (strong, nonatomic) NSArray *ingridients;
@property (copy, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSArray *badges;

@property (assign, nonatomic) BOOL isNoItems;

@property (strong, nonatomic) ZPPEnergy *energy;

@end

//"id": 21,
//"name": "Indian pea",
//"description": "Jerky short ribs ham hock pork loin turkey meatball shankle pork chop.",
//"price": 205,
//"image_url": "/uploads/dish/image/21/203c91cd55470d81fb521fed9f8a55c6.jpg",
//"ingredients":
@implementation ZPPDish

- (instancetype)initWithName:(NSString *)name
                      dishID:(NSString *)dishID
                    subtitle:(NSString *)subtitle
             dishDescription:(NSString *)dishDescription
                       price:(NSNumber *)price
                      imgURL:(NSString *)urlAsString
                 ingridients:(NSArray *)ingridients
                      badges:(NSArray *)badges
                     noItems:(BOOL)noItems
                      energy:(ZPPEnergy *)energy {
  self = [super init];
  if (self) {
    self.name = name;
    self.dishID = dishID;
    if (![subtitle isEqual:[NSNull null]]) {
      self.subtitle = subtitle;
    } else {
      self.subtitle = nil;
    }
    self.dishDescription = dishDescription;
    self.price = price;
    self.urlAsString = urlAsString;
    self.ingridients = ingridients;

    self.energy = energy;

    self.badges = badges;

    self.isNoItems = noItems;
  }
  return self;
}

- (NSInteger)priceOfItem {
  return [self.price integerValue];
}

- (NSString *)nameOfItem {
  return self.name;
}

- (NSString *)identifierOfItem {
  return self.dishID;
}

- (NSURL *)URLOfImage {
  NSURL *res;
  if (self.urlAsString) {
    res = [NSURL URLWithString:self.urlAsString];
  }
  return res;
}

@end
