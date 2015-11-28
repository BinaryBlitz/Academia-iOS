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
#import <DateTools.h>

@implementation ZPPOrderHistoryCell

- (void)configureWithOrder:(ZPPOrder *)order {
    NSString *dateString =
        [NSString stringWithFormat:@"Заказ от %ld.%ld.%ld", [order.date day],
                                   [order.date month], [order.date year]];
    self.orderName.text = dateString;

    //    NSString *descrString = @"";
    //    for (ZPPOrderItem *item in order.items) {
    //        NSString *str = [item.item nameOfItem];
    //        if (descrString.length != 0) {
    //            str = [@", " stringByAppendingString:str];
    //        } else {
    //            str = [str capitalizedString];
    //        }
    //        descrString = [descrString stringByAppendingString:str];
    //    }

    self.descrLabel.text = [order orderDescr];  // descrString;

    self.priceLabel.text = [NSString
        stringWithFormat:@"На сумму: %@%@", @([order totalPrice]), ZPPRoubleSymbol];
}

@end
