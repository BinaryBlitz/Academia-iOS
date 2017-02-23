@import Foundation;

@class ZPPAddress;
@class LMAddress;

@interface ZPPAddressHelper : NSObject

+ (ZPPAddress *)addressFromAddress:(LMAddress *)addr;
+ (ZPPAddress *)addressFromDict:(NSDictionary *)dict;
+ (NSArray *)addressesFromDaDataDictionaries:(NSArray *)dictionaries;
+ (NSArray *)parsePoints:(NSArray *)points;

@end
