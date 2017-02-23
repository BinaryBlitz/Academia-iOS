#import "ZPPGift.h"
#import "ZPPConsts.h"

@interface ZPPGift ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *giftDescription;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSNumber *giftIdentifier;

@end

@implementation ZPPGift

- (instancetype)initWith:(NSString *)name
             description:(NSString *)giftDescription
                   price:(NSNumber *)price
              identifier:(NSNumber *)giftIdentifier {
  self = [super init];
  if (self) {
    self.name = name;
    self.giftDescription = giftDescription;
    self.price = price;
    self.giftIdentifier = giftIdentifier;
  }
  return self;
}

- (NSString *)nameOfItem {
  return [NSString stringWithFormat:@"%@ на %@%@", self.name, self.price, ZPPRoubleSymbol];
}

- (NSInteger)priceOfItem {
  return self.price.integerValue;
}

- (NSString *)identifierOfItem {
  return [NSString stringWithFormat:@"%@", self.giftIdentifier];
}

@end
