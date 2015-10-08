//
//  ZPPMainVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPMainVC.h"

//libs
#import <VBFPopFlatButton.h>

@interface ZPPMainVC ()
@property (strong, nonatomic) VBFPopFlatButton *menuButton;
@end

@implementation ZPPMainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
     [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    // Dispose of any resources that can be recreated.
}

#pragma mark - ui

- (BOOL)prefersStatusBarHidden {
    return YES;
}

//-(VBFPopFlatButton *)menuButton {
//    if(!_menuButton) {
//        _menuButton = [VBFPopFlatButton bu]
//    }
//}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
