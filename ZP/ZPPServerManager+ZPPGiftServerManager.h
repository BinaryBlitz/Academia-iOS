#import "ZPPServerManager.h"

@interface ZPPServerManager (ZPPGiftServerManager)

- (void)GETGiftsOnSuccess:(void (^)(NSArray *gifts))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
