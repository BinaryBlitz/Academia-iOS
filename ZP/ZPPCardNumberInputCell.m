//
//  ZPPCardNumberInputCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardNumberInputCell.h"
//#import <BKCardNumberField.h>
@import BKMoneyKit;
#import "UIView+UIViewCategory.h"

@implementation ZPPCardNumberInputCell

- (void)awakeFromNib {
    self.cardNumberTextField.showsCardLogo = YES;
    [self.cardNumberTextField makeBordered];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
