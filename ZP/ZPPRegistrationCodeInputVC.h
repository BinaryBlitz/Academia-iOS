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

-(void)setUser:(ZPPUser *)user;

@end
