#import "ZPPBadge.h"

@implementation ZPPBadge

- (instancetype)initWithName:(NSString *)name
                    imageURL:(NSURL *)imgURL
                  identifier:(NSString *)identifier {
  self = [super init];
  if (self) {
    self.imgURL = imgURL;
    self.name = name;
    self.identifier = identifier;
  }
  return self;
}

- (NSURL *)URLOfImage {
  return self.imgURL;
}

@end
