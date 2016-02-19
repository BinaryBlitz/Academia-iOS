//
//  ZPPOrderHistoryCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderHistoryCell.h"
#import "ZPPOrder.h"
#import "ZPPOrderItem.h"

#import "ZPPConsts.h"
//#import <DateTools.h>
@import DateTools;

@implementation ZPPOrderHistoryCell

- (void)configureWithOrder:(ZPPOrder *)order {
    NSString *dateString =
        [NSString stringWithFormat:@"Заказ от %ld.%ld.%ld", [order.date day],
                                   [order.date month], [order.date year]];
    self.orderName.text = dateString;

    self.descrLabel.text = [order orderDescr];  // descrString;

//    [order totalPriceWithDelivery]
    self.priceLabel.text = [NSString
        stringWithFormat:@"На сумму: %@%@", @([order totalPriceWithDelivery]), ZPPRoubleSymbol];
}

@end
