//
//  ZPPOrderAddressCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderAddressCell.h"
#import "ZPPAddress.h"

@implementation ZPPOrderAddressCell

- (void)configureWithAddress:(ZPPAddress *)address {
    self.addresDescrLabel.text = @"Адрес доставки";
    self.addresLabel.text = [NSString stringWithFormat:@"%@", [address formatedDescr]];

        //   [self.chooseAnotherButton setTitle:@"Выбрать другой адерс" forState:UIControlStateNormal];

    NSDictionary *underlineAttribute =
        @{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    NSAttributedString *attrStr =
        [[NSAttributedString alloc] initWithString:@"Выбрать другой адерс"
                                        attributes:underlineAttribute];

    [self.chooseAnotherButton setAttributedTitle:attrStr forState:UIControlStateNormal];
}

@end
