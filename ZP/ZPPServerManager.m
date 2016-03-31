//
//  ZPPServerManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager.h"
#import "AFNetworking.h"

#import "CocoaLumberjack.h"

// typedef void (^failureBlock)(NSError *error, NSInteger statusCode);

// static const int ddLogLevel = DDLogLevelInfo;

NSString *const ZPPServerBaseUrl = @"http://128.199.51.211/";
//NSString *const ZPPServerBaseUrl = @"http://zpapp.binaryblitz.ru/";

NSString *const ZPPNoInternetConnectionMessage = @"Проверьте интернет " @"соедине"
                                                                                         @"ние";

@interface ZPPServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (copy, nonatomic) NSString *baseURL;

@end

@implementation ZPPServerManager

+ (ZPPServerManager *)sharedManager {
    static ZPPServerManager *manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZPPServerManager alloc] init];
    });

    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *apiPath = [NSString stringWithFormat:@"%@", ZPPServerBaseUrl];  //, @"api"];
        self.baseURL = apiPath;
        //[NSString stringWithFormat:@"http://%@:%@/", @"192.168.1.39", @"3000"];
        NSURL *url = [NSURL URLWithString:apiPath];
        // url.port = @3000;

        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
    }
    return self;
}

//#pragma mark - categories and topics

//- (void)GETCategoriesOnSuccess:(void (^)(NSArray *topics))successAF
// onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
//
//
//}

#pragma mark - support

+ (void)failureWithBlock:(failureBlock)block
                   error:(NSError *)error
               operation:(AFHTTPRequestOperation *)operation {
    DDLogError(@"err %@ \nerr resp %@", error, operation.responseObject);
    if (block) {
        block(error, operation.response.statusCode);
    }
}

@end