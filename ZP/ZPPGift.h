//
//  ZPPGift.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"

@interface ZPPGift : NSObject <ZPPItemProtocol>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *giftDescription;
@property (strong, nonatomic, readonly) NSNumber *price;

- (instancetype)initWith:(NSString *)name
             description:(NSString *)giftDescription
                   price:(NSNumber *)price;

- (NSInteger)priceOfItem;
- (NSString *)nameOfItem;

@end
