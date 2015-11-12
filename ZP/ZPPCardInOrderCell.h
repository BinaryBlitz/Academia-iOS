//
//  ZPPCardInOrderCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 10/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BKCardNumberLabel;
@class ZPPCreditCard;

@interface ZPPCardInOrderCell : UITableViewCell

@property (weak, nonatomic) IBOutlet BKCardNumberLabel *cardNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *expirationLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseAnotherButton;

- (void)configureWithCard:(ZPPCreditCard *)card;

@end
