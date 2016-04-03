//
//  ZPPServerManager+ZPPGiftServerManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPGiftServerManager.h"
#import "ZPPUserManager.h"
#import "ZPPGiftHelper.h"
#import "AFNetworking.h"

@implementation ZPPServerManager (ZPPGiftServerManager)

- (void)GETGiftsOnSuccess:(void (^)(NSArray *gifts))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {//redo test
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       if (success) {
                           success([ZPPGiftHelper parseGiftFromDicts:nil]);
                       }
                   });
}

@end
