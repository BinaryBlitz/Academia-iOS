//
//  ZPPRegistrationBaseVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 18/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationBaseVC.h"

@implementation ZPPRegistrationBaseVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  [self registerForKeyboardNotifications];
  //[self setNeedsStatusBarAppearanceUpdate];
}

- (void)viewWillDisappear:(BOOL)animated {
  [super viewWillDisappear:animated];

  [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registerForKeyboardNotifications {
  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillShow:)
                                               name:UIKeyboardWillShowNotification
                                             object:nil];

  [[NSNotificationCenter defaultCenter] addObserver:self
                                           selector:@selector(keyboardWillHide:)
                                               name:UIKeyboardWillHideNotification
                                             object:nil];
}

- (void)keyboardWillShow:(NSNotification *)aNotification {
  NSDictionary *info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

  [self.view layoutIfNeeded];
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.bottomConstraint.constant = kbSize.height;
                     [self.mainTF.superview layoutIfNeeded];
                     [self.view layoutIfNeeded];
                   }];
}

- (void)keyboardWillHide:(NSNotification *)aNotification {
  [self.view layoutIfNeeded];
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.bottomConstraint.constant = 0;
                     [self.view layoutIfNeeded];
                   }];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
