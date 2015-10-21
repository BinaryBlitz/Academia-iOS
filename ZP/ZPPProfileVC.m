//
//  ZPPProfileVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProfileVC.h"
#import "ZPPUserManager.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"

@interface ZPPProfileVC ()



@end
@implementation ZPPProfileVC

-(void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    ZPPUser *u = [ZPPUserManager sharedInstance].user;
    
    self.nameTextField.text = u.firstName;
    self.secondNameTextField.text = u.lastName;
    self.emailTextFild.text = u.email;
    
}

- (IBAction)saveAction:(id)sender {
    ZPPUser *u = [ZPPUserManager sharedInstance].user;
    if(![self.nameTextField.text isEqualToString:u.firstName]) {
        
    }
    
    if(![self.secondNameTextField.text isEqualToString:u.lastName]) {
        
    }
    
    if(![self.emailTextFild.text isEqualToString:u.email]) {
        
    }
    
    
}

- (IBAction)logOutAction:(UIButton *)sender {
    [[ZPPUserManager sharedInstance] userLogOut];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    });
}

@end
