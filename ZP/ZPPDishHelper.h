#import <Foundation/Foundation.h>

@class ZPPDish;

@interface ZPPDishHelper : NSObject

+ (NSArray *)parseDishes:(NSArray *)dishes;
+ (ZPPDish *)dishFromDict:(NSDictionary *)dict;


@end
