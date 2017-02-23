#import "UIFont+ZPPFontCategory.h"

@implementation UIFont (ZPPFontCategory)

+ (UIFont *)fontOfSize:(CGFloat)fontSize {
  return [[self class] systemFontOfSize:fontSize];
}

+ (UIFont *)boldFontOfSize:(CGFloat)fontSize {
  return [[self class] boldSystemFontOfSize:fontSize];
}

@end
