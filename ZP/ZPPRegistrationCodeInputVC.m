//
//  ZPPRegistrationCodeInputVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPRegistrationCodeInputVC.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "ZPPRegistrationOtherInputVC.h"
#import "ZPPUser.h"
#import "UIView+UIViewCategory.h"

static NSString *ZPPShowRegistrationOtherScreenSegueIdentifier =
    @"ZPPShowRegistrationOtherScreenSegueIdentifier";

static NSString *ZPPCodeWarningMessage = @"Неправильный код";
@interface ZPPRegistrationCodeInputVC ()
//@property (strong, nonatomic) UIView *bottomSuper

@property (strong, nonatomic) ZPPUser *user;
@end

@implementation ZPPRegistrationCodeInputVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mainTF = self.codeTextField;
    self.bottomConstraint = self.bottomSuperviewConstraint;
    
    [self.codeTextField makeBordered];
       // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setCustomBackButton];
    [self addCustomCloseButton];

  //  [self registerForKeyboardNotifications];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [self.codeTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
   // [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUser:(ZPPUser *)user {
    _user = user;
}

//- (void)registerForKeyboardNotifications {
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillShow:)
//                                                 name:UIKeyboardWillShowNotification
//                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(keyboardWillHide:)
//                                                 name:UIKeyboardWillHideNotification
//                                               object:nil];
//}

//- (void)keyboardWillShow:(NSNotification *)aNotification {
//    NSDictionary *info = [aNotification userInfo];
//    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
//
//    [self.view layoutIfNeeded];
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         self.bottomSuperviewConstraint.constant = kbSize.height;
//                         [self.codeTextField.superview layoutIfNeeded];
//                         [self.view layoutIfNeeded];
//                     }];
//}
//
//- (void)keyboardWillHide:(NSNotification *)aNotification {
//    [self.view layoutIfNeeded];
//    [UIView animateWithDuration:0.3
//                     animations:^{
//                         self.bottomSuperviewConstraint.constant = 0;
//                         [self.view layoutIfNeeded];
//                     }];
//}

- (IBAction)submitCodeAction:(id)sender {
    
    if(![self checkCode]){
        [self accentTextField:self.codeTextField];
        [self showWarningWithText:ZPPCodeWarningMessage];
    } else {
    [self performSegueWithIdentifier:ZPPShowRegistrationOtherScreenSegueIdentifier sender:nil];
    }
}

- (BOOL)checkCode {
    return NO;
}



#pragma mark - navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:ZPPShowRegistrationOtherScreenSegueIdentifier]) {
        
        ZPPRegistrationOtherInputVC *destVC =
        (ZPPRegistrationOtherInputVC *)segue.destinationViewController;
        
        ZPPUser *user = [self user];
        
        [destVC setUser:user];
        
        
    }
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
