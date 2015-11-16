//
//  ZPPServerManager+ZPPGiftServerManager.h
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager.h"

@interface ZPPServerManager (ZPPGiftServerManager)

- (void)GETGiftsOnSuccess:(void (^)(NSArray *gifts))success
                onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
