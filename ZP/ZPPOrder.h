//
//  ZPPOrder.h
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import Foundation;
#import "ZPPItemProtocol.h"

typedef NS_ENUM(NSInteger, ZPPOrderStatus) {
    ZPPOrderStatusNew,
    ZPPOrderStatusOnTheWay,
    ZPPOrderStatusRejected,
    ZPPOrderStatusDelivered,
    ZPPOrderStatusNotSended
};

@class ZPPAddress;
@class ZPPOrderItem;
@class ZPPCreditCard;

@interface ZPPOrder: NSObject

@property (strong, nonatomic, readonly) NSMutableArray *items;
@property (strong, nonatomic) NSDate *date;
@property (strong, nonatomic) ZPPAddress *address;
@property (strong, nonatomic) ZPPCreditCard *card;

@property (assign, nonatomic) double starValue;
@property (nonatomic) BOOL deliverNow;
@property (strong, nonatomic) NSString *commentString;

@property (strong, nonatomic) NSString *identifier;
@property (strong, nonatomic) NSString *alfaNumber;
@property (assign, nonatomic) ZPPOrderStatus orderStatus;

- (instancetype)initWithIdentifier:(NSString *)identifier
                             items:(NSMutableArray *)items
                           address:(ZPPAddress *)address
                       orderStatus:(ZPPOrderStatus)status
                              date:(NSDate *)date
                            review:(NSString *)review
                            rating:(float)rating;

- (void)addItem:(id<ZPPItemProtocol>)item;
- (void)removeItem:(id<ZPPItemProtocol>)item;
- (ZPPOrderItem *)orderItemForItem:(id<ZPPItemProtocol>)item;
- (void)checkAllAndRemoveEmpty;
- (NSInteger)totalCount;
- (NSInteger)totalPrice;
- (NSInteger)totalPriceWithDelivery;
- (BOOL)deliveryIncluded;
- (NSString *)orderDescr;
- (void)clearOrder;

@end
