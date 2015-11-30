//
//  ZPPOrderResultVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderResultVC.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPConsts.h"

@implementation ZPPOrderResultVC

- (void)viewDidLoad {
    [super viewDidLoad];

  //  [self.callCourierButton makeBorderedWithColor:[UIColor whiteColor]];

    [self.backToMenuButton makeBorderedWithColor:[UIColor whiteColor]];
    
    self.navigationItem.hidesBackButton = YES;
    
    
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    [self.backToMenuButton addTarget:self
                              action:@selector(closeScreen)
                    forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
