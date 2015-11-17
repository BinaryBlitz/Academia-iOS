//
//  ZPPRegistrationCodeInputVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

//#import <UIKit/UIKit.h>
#import "ZPPRegistrationBaseVC.h"
@class ZPPUser;

@interface ZPPRegistrationCodeInputVC : ZPPRegistrationBaseVC
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomSuperviewConstraint;
@property (weak, nonatomic) IBOutlet UITextField *codeTextField;
@property (weak, nonatomic) IBOutlet UIButton *againCodeButton;

@property (strong, nonatomic) ZPPUser *user;
@property (strong, nonatomic) NSString *code;

////- (void)setUser:(ZPPUser *)user;
//- (void)setCode:(NSString *)code;

- (BOOL)checkCode;



@end
