//
//  ZPPOrderTimeChooserVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPPOrder;

@interface ZPPOrderTimeChooserVC : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *nowButton;
@property (weak, nonatomic) IBOutlet UIButton *atTimeButton;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *makeOrderButton;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
