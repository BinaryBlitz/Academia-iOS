#import <Foundation/Foundation.h>

@class ZPPOrder;

@interface ZPPOrderHelper : NSObject

+ (NSArray *)parseOrdersFromDicts:(NSArray *)dicts;
+ (NSDictionary *)orderDictFromOrder:(ZPPOrder *)order;
+ (ZPPOrder *)parseOrderFromDict:(NSDictionary *)dict;

@end
