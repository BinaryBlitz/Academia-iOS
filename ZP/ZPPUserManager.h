#import <Foundation/Foundation.h>
#import "ZPPUser.h"

extern NSString *const ZPPUserLogoutNotificationName;

@interface ZPPUserManager : NSObject

@property (strong, nonatomic, readonly) ZPPUser *user;
@property (strong, nonatomic, readonly) NSString *pushToken;
@property (strong, nonatomic, readonly) NSData *pushTokenData;

+ (instancetype)sharedInstance;
- (void)setAPNsToken:(NSData *)pushTokenData;
- (void)setUser:(ZPPUser *)user;
- (BOOL)checkUser;
- (void)userLogOut;

@end
