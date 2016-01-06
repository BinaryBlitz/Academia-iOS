//
//  ZPPOrderResultVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Crashlytics/Crashlytics.h>
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPConsts.h"
#import "ZPPOrderResultVC.h"

@implementation ZPPOrderResultVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [Answers logCustomEventWithName:@"ORDER_MADE" customAttributes:@{}];

    //  [self.callCourierButton makeBorderedWithColor:[UIColor whiteColor]];

    [self.backToMenuButton makeBorderedWithColor:[UIColor whiteColor]];

    self.navigationItem.hidesBackButton = YES;

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    [self.backToMenuButton addTarget:self
                              action:@selector(closeScreen)
                    forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *underlineAttribute = @{
        NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle),
        NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.f]
    };
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.phoneTextView.text
                                                                  attributes:underlineAttribute];

    self.phoneTextView.attributedText = attrStr;
    self.phoneTextView.textAlignment = NSTextAlignmentCenter;
}

- (void)closeScreen {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
