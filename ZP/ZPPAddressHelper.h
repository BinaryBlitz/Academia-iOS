@import Foundation;

@class ZPPAddress;
@class LMAddress;

@interface ZPPAddressHelper : NSObject

+ (ZPPAddress *)addresFromAddres:(LMAddress *)addr;
+ (ZPPAddress *)addressFromDict:(NSDictionary *)dict;
+ (NSArray *)addressesFromDaDataDicts:(NSArray *)dicts;

+ (NSArray *)parsePoints:(NSArray *)points;


@end
