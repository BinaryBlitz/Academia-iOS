#import "ZPPStuffHelper.h"
#import "ZPPStuff.h"

#import "ZPPImageWorker.h"

@implementation ZPPStuffHelper

+ (ZPPStuff *)stuffFromDict:(NSDictionary *)dict {
  NSString *name = dict[@"name"];
  // NSString *subtitle = dict[@"subtitle"];
  NSNumber *identifier = dict[@"id"];
  NSNumber *price = dict[@"price"];
  NSString *stuffDescription = dict[@"description"];
  NSString *urlAppend = dict[@"image_url"];

//    NSString *urlAsString = [NSString stringWithFormat:@"%@%@", ZPPServerBaseUrl, urlAppend];
  NSURL *imgURL = [NSURL URLWithString:urlAppend];

  ZPPStuff *s = [[ZPPStuff alloc] initWithName:name
                                    identifier:identifier
                                         descr:stuffDescription
                                         price:price
                                        imgURL:imgURL];

  return s;
}

+ (NSArray *)parseStuff:(NSArray *)dishes {
  NSMutableArray *tmpArr = [NSMutableArray array];
  for (NSDictionary *d in dishes) {
    ZPPStuff *l = [[self class] stuffFromDict:d];
    [tmpArr addObject:l];
  }

  NSArray *arr = [NSArray arrayWithArray:tmpArr];

  [ZPPImageWorker preheatImagesOfObjects:arr];

  return arr;
}

@end
