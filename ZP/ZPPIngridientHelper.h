#import <Foundation/Foundation.h>

@class ZPPIngridient;

@interface ZPPIngridientHelper : NSObject

//+ (ZPPIngridient *)ingridientFromDict:(NSDictionary *)dict ;
+ (NSArray *)parseIngridients:(NSArray *)ingridients;

@end
