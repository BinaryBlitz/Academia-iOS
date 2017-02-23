//
//  ZPPCreditCardInfoCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;

@class ZPPCreditCard;

@interface ZPPCreditCardInfoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *checkmarkImageView;
@property (weak, nonatomic) IBOutlet UILabel *cardNumberLabel;

@end
