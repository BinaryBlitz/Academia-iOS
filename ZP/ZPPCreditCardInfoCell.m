//
//  ZPPCreditCardInfoCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCreditCardInfoCell.h"
#import "ZPPCreditCard.h"

#import "BKCardNumberLabel.h"

@implementation ZPPCreditCardInfoCell

- (void)awakeFromNib {
    // Initialization code

    self.cardNumberLabel.showsCardLogo = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithCard:(ZPPCreditCard *)card {
//    self.cardNumberLabel.cardNumber = card.cardNumber;
    self.cardNumberLabel.cardNumberFormatter.maskingCharacter = @"●";
    self.cardNumberLabel.cardNumberFormatter.maskingGroupIndexSet =
        [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    self.cardNumberLabel.cardNumber = card.cardNumber;

    self.expirationLabel.text = [card formattedDate];
}

@end
