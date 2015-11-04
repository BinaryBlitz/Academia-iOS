//
//  ZPPOrder.h
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"

@interface ZPPOrder : NSObject

@property (strong, nonatomic, readonly) NSMutableArray *items;

@property (strong, nonatomic,readonly) NSDate *date;

- (void)addItem:(id<ZPPItemProtocol>)item;

- (void)removeItem:(id<ZPPItemProtocol>)item;

- (NSInteger)totalCount;

- (NSInteger)totalPrice;

@end
