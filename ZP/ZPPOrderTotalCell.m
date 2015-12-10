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

    if (order.orderStatus == ZPPOrderStatusNotSended) {
        if ([order deliveryIncluded]) {
            self.deliveryPriceLabel.text = @"+ доставка 200₽";
            self.deliveryLabel.text = @"Бесплатная доставка от 1000₽";
        } else {
            self.deliveryPriceLabel.text = @"Доставка бесплатна";
            self.deliveryLabel.text = @"";
        }

    } else {
        if ([order deliveryIncluded]) {
            self.deliveryPriceLabel.text = @"+ доставка 200₽";
            self.deliveryLabel.text = @"";
        } else {
            self.deliveryPriceLabel.text = @"Доставка бесплатна";
            self.deliveryLabel.text = @"";
        }
    }
}

@end
