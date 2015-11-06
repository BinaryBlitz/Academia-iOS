//
//  ZPPChangePasswordVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ZPPRegistrationBaseVC.h"

@interface ZPPChangePasswordVC : ZPPRegistrationBaseVC;
@property (weak, nonatomic) IBOutlet UITextField *oldPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *userNewPasswordTextField;
@property (weak, nonatomic) IBOutlet UITextField *againPasswordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *superViewBottomConstr;

@end
