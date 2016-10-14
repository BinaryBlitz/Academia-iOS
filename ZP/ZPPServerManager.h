//
//  ZPPServerManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//


@import Foundation;
//@import CocoaLumberjack;

//static const int ddLogLevel = DDLogLevelDebug;

extern NSString *_Nonnull const ZPPServerBaseUrl;
extern NSString *_Nonnull const ZPPNoInternetConnectionMessage;

typedef void (^failureBlock)(NSError *_Nullable error, NSInteger statusCode);
@class AFHTTPRequestOperation;
@class AFHTTPRequestOperationManager;

@interface ZPPServerManager : NSObject

@property (strong, nonatomic, readonly)
    AFHTTPRequestOperationManager *_Nullable requestOperationManager;

+ (nonnull ZPPServerManager *)sharedManager;
+ (void)failureWithBlock:(nullable failureBlock)block
                   error:(nullable NSError *)error
               operation:(nullable AFHTTPRequestOperation *)operation;
@end
