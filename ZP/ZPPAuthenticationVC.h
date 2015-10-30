//
//  ZPPAuthenticationVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 29/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationBaseVC.h"

@interface ZPPAuthenticationVC : ZPPRegistrationBaseVC

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSuperviewConstraint;
//@property (weak, nonatomic) IBOutlet UITextField *codeTextField;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *doneButton;
@property (weak, nonatomic) IBOutlet UIButton *renewPasswordButton;

@end
