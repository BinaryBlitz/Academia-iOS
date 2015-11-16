//
//  ZPPOrderItemCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 30/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderItemCell.h"
#import "ZPPOrderItem.h"

@implementation ZPPOrderItemCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithOrderItem:(ZPPOrderItem *)orderItem {
    self.countLabel.text = [NSString stringWithFormat:@"%@ X", @(orderItem.count)];
    self.nameLabel.text = [orderItem.item nameOfItem];
    self.priceLabel.text = [NSString stringWithFormat:@"%@₽", @([orderItem totalPrice])];
}

@end
