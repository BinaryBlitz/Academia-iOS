//
//  ZPPProfileVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

//#import "ZPPRegistrationOtherInputVC.h"
#import <UIKit/UIKit.h>

@class ZPPCustomTextField;

@interface ZPPProfileVC : UITableViewController

@property (weak, nonatomic) IBOutlet ZPPCustomTextField *nameTextField;
@property (weak, nonatomic) IBOutlet ZPPCustomTextField *secondNameTextField;
@property (weak, nonatomic) IBOutlet ZPPCustomTextField *emailTextField;
@property (weak, nonatomic) IBOutlet UIButton *changePasswordButton;
@property (weak, nonatomic) IBOutlet UIButton *saveProfileButton;

@end
