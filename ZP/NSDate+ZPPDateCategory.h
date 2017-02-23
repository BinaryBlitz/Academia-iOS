#import <Foundation/Foundation.h>

@interface NSDate (ZPPDateCategory)

- (NSString *)timeStringfromDate;
- (NSString *)dateStringFromDate;
+ (NSDate *)customDateFromString:(NSString *)dateAsString;

- (NSString *)serverFormattedString;

@end
