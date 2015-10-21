//
//  UIViewController+ZPPViewControllerCategory.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UIViewController+ZPPViewControllerCategory.h"

@implementation UIViewController (ZPPViewControllerCategory)

- (void)setCustomBackButton {
    UIButton *backButton = [self buttonWithImageName:@"arrowBack"];
    [backButton addTarget:self
                   action:@selector(popBack)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    self.navigationItem.leftBarButtonItem = backButtonItem;
}

- (void)popBack {
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)addCustomCloseButton {
    UIButton *closeButton = [self buttonWithImageName:@"cross"];
    [closeButton addTarget:self
                   action:@selector(dismisVC)
         forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    self.navigationItem.rightBarButtonItem = closeButtonItem;
    
    
}

-(void)dismisVC {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(UIButton *)buttonWithImageName:(NSString *)imgName {
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30.0f, 30.0f)];
    backButton.tintColor = [UIColor whiteColor];
    UIImage *backImage = [[UIImage imageNamed:imgName]
                          imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backButton setBackgroundImage:backImage forState:UIControlStateNormal];
    [backButton setTitle:@"" forState:UIControlStateNormal];
    
    return backButton;
}

- (UITableViewCell *)parentCellForView:(id)theView {
    id viewSuperView = [theView superview];
    while (viewSuperView != nil) {
        if ([viewSuperView isKindOfClass:[UITableViewCell class]]) {
            return (UITableViewCell *)viewSuperView;
        } else {
            viewSuperView = [viewSuperView superview];
        }
    }
    return nil;
}





@end
