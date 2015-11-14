//
//  ZPPServerManager+ZPPPromoCodeManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager.h"

extern NSString *const ZPPWrongCardNumber;

@interface ZPPServerManager (ZPPPromoCodeManager)

- (void)POSTPromocCode:(NSString *)code
             onSuccess:(void (^)())success
             onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
