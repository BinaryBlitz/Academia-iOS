//
//  ZPPCreditCardInfoCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKCardNumberLabel;
@class ZPPCreditCard;

@interface ZPPCreditCardInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BKCardNumberLabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationLabel;


- (void)configureWithCard:(ZPPCreditCard *)card;

@end
