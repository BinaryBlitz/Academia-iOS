//
//  ZPPRegistrationOtherInputVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationOtherInputVC.h"
//#import "ZPPRegistrationServerManager.h"
#import "ZPPServerManager+ZPPRegistration.h"
#import "ZPPUser.h"
#import "ZPPUserManager.h"
#import "ZPPRegistrationSuccesVC.h"

#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIButton+ZPPButtonCategory.h"
#import "UIView+UIViewCategory.h"

static NSString *ZPPShowRegistrationResultSegueIdentifier =
    @"ZPPShowRegistrationResultSegueIdentifier";

@interface ZPPRegistrationOtherInputVC () <UITextFieldDelegate>

@property (strong, nonatomic) NSArray *textFields;
@property (strong, nonatomic) ZPPUser *user;

@end

@implementation ZPPRegistrationOtherInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    NSMutableArray *arr = [NSMutableArray array];

    [arr addObject:self.nameTextField];
    [arr addObject:self.secondNameTextField];
    [arr addObject:self.emailTextFild];
    [arr addObject:self.passwordTextField];
    [arr addObject:self.againPasswordTextField];

    self.textFields = [NSArray arrayWithArray:arr];

    for (UITextField *tf in self.textFields) {
        [tf makeBordered];
        tf.delegate = self;
    }

    [self configureBackgroundImage];
    [self addCustomCloseButton];
    [self.navigationItem
        setLeftBarButtonItem:[[UIBarButtonItem alloc] initWithCustomView:[[UIView alloc] init]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.nameTextField becomeFirstResponder];
}

- (void)setUser:(ZPPUser *)user {
    _user = user;
}

- (IBAction)saveProfileAction:(UIButton *)sender {
    [self saveAction:sender];
}

- (void)saveAction:(UIButton *)sender {
    if (![self chekAll]) {
        return;
    }

    [self configureUser];
    [sender startIndicating];
    [[ZPPServerManager sharedManager] POSTRegistrateUser:self.user
        onSuccess:^(ZPPUser *user) {
            [sender stopIndication];
            [[ZPPUserManager sharedInstance] setUser:user];

            self.user = user;

            [self performSegueWithIdentifier:ZPPShowRegistrationResultSegueIdentifier sender:nil];
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [sender stopIndication];
        }];

    //  [ZPPRegistrationServerManager sharedManager] post
}

- (BOOL)chekAll {
    if (![self checkNameTextField:self.nameTextField]) {
        [self accentTextField:self.nameTextField];
        return NO;
    }

    if (![self checkNameTextField:self.secondNameTextField]) {
        [self accentTextField:self.secondNameTextField];
        return NO;
    }

    if (![self checkEmailTextField:self.emailTextFild]) {
        [self accentTextField:self.emailTextFild];
        return NO;
    }

    if (![self checkPasswordTextFied:self.passwordTextField]) {
        [self accentTextField:self.passwordTextField];
        return NO;
    }

    if (![self checkPasswordEqualty:self.passwordTextField second:self.againPasswordTextField]) {
        [self accentTextField:self.againPasswordTextField];
        return NO;
    }

    return YES;
}

//- (void)accentTextField:(UITextField *)tf {
//    [tf shakeView];
//    [tf becomeFirstResponder];
//}

- (void)configureUser {
    self.user.firstName = self.nameTextField.text;
    self.user.lastName = self.secondNameTextField.text;
    self.user.password = self.passwordTextField.text;
    self.user.email = self.emailTextFild.text;
}

//-(BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
// navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.

    if ([segue.identifier isEqualToString:ZPPShowRegistrationResultSegueIdentifier]) {
        ZPPRegistrationSuccesVC *destVC =
            (ZPPRegistrationSuccesVC *)segue.destinationViewController;

        [destVC setUser:self.user];
    }
}

#pragma mark - back img

- (void)configureBackgroundImage {
    CGRect r = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),
                          16 * CGRectGetWidth([UIScreen mainScreen].bounds) / 9);

    UIImageView *iv = [[UIImageView alloc] initWithFrame:r];

    iv.image = [UIImage imageNamed:@"back1"];

    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = iv;
}

@end
