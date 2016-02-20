//
//  ZPPRulesVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 06/01/16.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPRulesVC.h"

NSString *const ZPPRulesVCID = @"ZPPRulesVCID";

@implementation ZPPRulesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];

    self.title = @"Правила";
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.translucent = NO;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor whiteColor]}];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.textView.scrollEnabled = NO;
    self.textView.scrollEnabled = YES;
}

@end
