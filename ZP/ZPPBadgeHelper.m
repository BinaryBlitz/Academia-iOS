#import "ZPPBadgeHelper.h"
#import "ZPPBadge.h"
#import "ZPPImageWorker.h"

@implementation ZPPBadgeHelper

+ (ZPPBadge *)badgeWithDict:(NSDictionary *)dict {
  NSString *name = dict[@"name"];
  NSString *imgUrlAsString = dict[@"image_url"];
  NSString *identifier = dict[@"id"];

  NSURL *imgURL;
  if (imgUrlAsString && ![imgUrlAsString isEqual:[NSNull null]]) {
    imgURL = [NSURL URLWithString:imgUrlAsString];
  }

  ZPPBadge *badge = [[ZPPBadge alloc] initWithName:name imageURL:imgURL identifier:identifier];

  return badge;
}

+ (NSArray *)parseBadgeArray:(NSArray *)dicts {
  NSMutableArray *tmp = [NSMutableArray array];

  for (NSDictionary *d in dicts) {
    ZPPBadge *b = [[self class] badgeWithDict:d];

    [tmp addObject:b];
  }

  [ZPPImageWorker preheatImagesOfObjects:tmp];

  return [NSArray arrayWithArray:tmp];
}


@end
