//
//  ZPPPasswordRenewPasswordInput.h
//  ZP
//
//  Created by Andrey Mikhaylov on 17/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPChangePasswordVC.h"


@class ZPPUser;
@interface ZPPPasswordRenewPasswordInput : ZPPChangePasswordVC
@property (weak, nonatomic) IBOutlet UIButton *okButton;

- (void)configureWithUser:(ZPPUser *)user code:(NSString *)code;

@end
