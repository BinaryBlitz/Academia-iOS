//
//  ZPPGiftCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPGiftCell.h"
#import "ZPPGift.h"

@implementation ZPPGiftCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithGift:(ZPPGift *)gift {
    self.nameLabel.text = gift.name;
    self.giftDescriptionLabel.text = gift.giftDescription;
    self.priceLabel.text = [NSString stringWithFormat:@"%@",gift.price];
}

@end
