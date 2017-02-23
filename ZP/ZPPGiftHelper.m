#import "ZPPGiftHelper.h"
#import "ZPPGift.h"

static NSString *ZPPGiftDescription = @"Подарочная карта";

@implementation ZPPGiftHelper

+ (NSArray *)testGifts {
  //  NSString *descr = ZPPGiftDescription;
  ZPPGift *firstGift = [[ZPPGift alloc] initWith:ZPPGiftDescription
                                     description:nil
                                           price:@(3000)
                                      identifier:@(3000)];
  ZPPGift *secondGift = [[ZPPGift alloc] initWith:ZPPGiftDescription
                                      description:nil
                                            price:@(6000)
                                       identifier:@(6000)];
  ZPPGift *thirdGift = [[ZPPGift alloc] initWith:ZPPGiftDescription
                                     description:nil
                                           price:@(8000)
                                      identifier:@(8000)];

  return @[firstGift, secondGift, thirdGift];
}

+ (NSArray *)parseGiftFromDicts:(NSArray *)dicts {//redo
  return [[self class] testGifts];
}

@end
