@import Foundation;

extern NSString *const ZPPFirstName;
extern NSString *const ZPPLastName;
extern NSString *const ZPPUserEmail;
extern NSString *const ZPPPhoneNumber;
extern NSString *const ZPPAPIToken;
extern NSString *const ZPPUserID;
extern NSString *const ZPPUserPassword;
extern NSString *const ZPPUserPromocode;
extern NSString *const ZPPUserBalance;
extern NSString *const ZPPUserDiscount;

@class ZPPUser;

@interface ZPPUserHelper : NSObject

+ (NSDictionary *)convertUser:(ZPPUser *)user;
+ (ZPPUser *)userFromDict:(NSDictionary *)dict;

@end
