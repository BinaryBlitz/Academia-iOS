#import "ZPPServerManager.h"

extern NSString *const ZPPWrongCardNumber;

@interface ZPPServerManager (ZPPPromoCodeManager)

- (void)POSTPromocCode:(NSString *)code
             onSuccess:(void (^)())success
             onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
