//
//  ZPPOrder.h
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"

@class ZPPAddress;
@interface ZPPOrder : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *items;
@property (strong, nonatomic,readonly) NSDate *date;
@property (strong, nonatomic) ZPPAddress *address;

- (void)addItem:(id<ZPPItemProtocol>)item;

- (void)removeItem:(id<ZPPItemProtocol>)item;

- (void)checkAllAndRemoveEmpty;

- (NSInteger)totalCount;

- (NSInteger)totalPrice;

@end
