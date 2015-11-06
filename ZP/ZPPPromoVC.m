//
//  ZPPPromoVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPromoVC.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIButton+ZPPButtonCategory.h"

#import "ZPPConsts.h"

@interface ZPPPromoVC ()

@end

@implementation ZPPPromoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.bottomConstraint = self.bottomConstr;
    self.mainTF = self.codeTextField;

    [self.doneButton addTarget:self
                        action:@selector(confirmCode:)
              forControlEvents:UIControlEventTouchUpInside];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marl - actions

- (void)confirmCode:(UIButton *)sender {
    [sender startIndicating];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [sender stopIndication];

                       [self showSuccessWithText:@"Код добавлен"];
                       
                       self.codeTextField.text = @"";
                   });
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
