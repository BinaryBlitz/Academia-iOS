//
//  ZPPServerManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CocoaLumberjack.h"

static const int ddLogLevel = DDLogLevelDebug;

extern NSString *const ZPPServerBaseUrl;
extern NSString *const ZPPNoInternetConnectionMessage;

typedef void (^failureBlock)(NSError *_Nullable error, NSInteger statusCode);
@class AFHTTPRequestOperation;
@class AFHTTPRequestOperationManager;
@interface ZPPServerManager : NSObject
@property (strong, nonatomic, readonly)
    AFHTTPRequestOperationManager *_Nullable requestOperationManager;

+ (ZPPServerManager *)sharedManager;
+ (void)failureWithBlock:(failureBlock)block
                   error:(NSError *)error
               operation:(AFHTTPRequestOperation *)operation;
@end
