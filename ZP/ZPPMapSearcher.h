//
//  ZPPMapSearcher.h
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPMapSearcher : NSObject

- (void)searchAddres:(NSString *)addresString
           onSuccess:(void (^)(NSArray *addresses))success
           onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

+ (instancetype)shared;

@end
