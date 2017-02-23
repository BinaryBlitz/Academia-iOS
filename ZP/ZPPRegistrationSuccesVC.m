//
//  ZPPRegistrationSuccesVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 18/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationSuccesVC.h"
#import "ZPPUser.h"

#import "UINavigationController+ZPPNavigationControllerCategory.h"

@interface ZPPRegistrationSuccesVC ()

@property (strong, nonatomic) ZPPUser *user;

@end

@implementation ZPPRegistrationSuccesVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self.navigationItem
      setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}

- (void)setUser:(ZPPUser *)user {
  // _user = user;

  NSString *name = user.firstName;
  self.greatingLabel.text = [NSString
      stringWithFormat:@"Поздравляем, %@\n Вы зарегистрировались!",
                       name];

  _user = user;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self.navigationController presentTransparentNavigationBar];
  NSString *name = self.user.firstName;
  self.greatingLabel.text = [NSString
      stringWithFormat:@"Поздравляем, %@\n Вы зарегистрировались!",
                       name];
}

- (IBAction)makeOrderAction:(id)sender {
  [self dismissViewControllerAnimated:YES
                           completion:^{
                           }];
}

@end
