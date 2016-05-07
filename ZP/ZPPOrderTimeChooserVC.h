//
//  ZPPOrderTimeChooserVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;

@class ZPPOrder;

@interface ZPPOrderTimeChooserVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *nowButton;
@property (weak, nonatomic) IBOutlet UIButton *atTimeButton;
@property (weak, nonatomic) IBOutlet UIButton *makeOrderButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *nowButtonHeight;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceWithDelivery;
@property (weak, nonatomic) IBOutlet UILabel *balanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *discountLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
