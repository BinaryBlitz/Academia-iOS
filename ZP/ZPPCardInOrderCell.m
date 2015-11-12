//
//  ZPPCardInOrderCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 10/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardInOrderCell.h"
#import "ZPPCreditCard.h"

#import "BKCardNumberLabel.h"

@implementation ZPPCardInOrderCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithCard:(ZPPCreditCard *)card {
    self.cardNumberLabel.cardNumberFormatter.maskingCharacter = @"●";
    self.cardNumberLabel.cardNumberFormatter.maskingGroupIndexSet =
        [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)];
    self.cardNumberLabel.cardNumber = card.cardNumber;

    self.expirationLabel.text = [card formattedDate];

    NSDictionary *underlineAttribute =
        @{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    NSAttributedString *attrStr =
        [[NSAttributedString alloc] initWithString:@"Выбрать другую карту"
                                        attributes:underlineAttribute];

    [self.chooseAnotherButton setAttributedTitle:attrStr forState:UIControlStateNormal];
}

@end
