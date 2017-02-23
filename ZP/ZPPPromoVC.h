//
//  ZPPPromoVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationBaseVC.h"

@class ZPPCustomLabel;

@interface ZPPPromoVC : ZPPRegistrationBaseVC

@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstr;

@property (weak, nonatomic) IBOutlet ZPPCustomLabel *promocodeLabel;
@property (weak, nonatomic) IBOutlet UIButton *smsInviteButton;
@property (weak, nonatomic) IBOutlet UIButton *emailShare;
@property (weak, nonatomic) IBOutlet UIButton *socialMediaShare;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *additionalViewBottomConstraint;

@end
