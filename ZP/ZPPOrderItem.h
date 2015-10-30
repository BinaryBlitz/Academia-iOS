//
//  ZPPOrderItem.h
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"

@interface ZPPOrderItem : NSObject

@property (strong, nonatomic, readonly) id<ZPPItemProtocol> item;
@property (assign, nonatomic, readonly) NSInteger count;


- (instancetype)initWithItem:(id<ZPPItemProtocol>)item;
- (void)addOneItem;
- (void)removeOneItem;

@end
