//
//  ZPPOrderTotalCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTotalCell.h"
#import "ZPPOrder.h"

#import "ZPPConsts.h"

@implementation ZPPOrderTotalCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.priceLabel.text =
        [NSString stringWithFormat:@"ВАШ ЗАКАЗ НА: %@%@",
                                   @([order totalPriceWithDelivery]), ZPPRoubleSymbol];

    if ([order deliveryIncluded] && order.orderStatus == ZPPOrderStatusNotSended) {
        NSString *upperstr = [NSString stringWithFormat:@"Включая доставку 200%@", ZPPRoubleSymbol];
        // NSInteger upperStrLength = str.length;

        // NSAttributedString *atrStr =
        // if (order.orderStatus == ZPPOrderStatusNotSended) {
        NSInteger toFreeDelivery = 1000 - order.totalPrice;
        NSString *toFreeDeliveryString = [NSString
            stringWithFormat:@"\n до бесплатной доставки %ld%@", toFreeDelivery, ZPPRoubleSymbol];
        NSString *resString = [upperstr stringByAppendingString:toFreeDeliveryString];
        //    }

        NSMutableAttributedString *attrStr =
            [[NSMutableAttributedString alloc] initWithString:resString];

        UIFont *font = [UIFont fontWithName:@"HelveticaNeue-Light" size:14];

        [attrStr addAttribute:NSFontAttributeName
                        value:font
                        range:NSMakeRange(upperstr.length , toFreeDeliveryString.length)];

        self.deliveryLabel.attributedText = attrStr;

        //        self.deliveryLabel.text =
        //            str;  //[NSString stringWithFormat:@"+доставка 200%@",ZPPRoubleSymbol];
    } else {
        self.deliveryLabel.text = @"";
    }
}

@end
