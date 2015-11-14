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
#import "ZPPSmsVerificationManager.h"
#import "ZPPServerManager.h"

static NSString *ZPPShowRegistrationOtherScreenSegueIdentifier =
    @"ZPPShowRegistrationOtherScreenSegueIdentifier";

static NSString *ZPPCodeWarningMessage = @"Неправильный код";
@interface ZPPRegistrationCodeInputVC ()  //<UITextFieldDelegate>

@property (strong, nonatomic) ZPPUser *user;

@property (strong, nonatomic) NSString *code;
@end

@implementation ZPPRegistrationCodeInputVC

- (void)viewDidLoad {
    [super viewDidLoad];

    if ([[ZPPSmsVerificationManager shared] canSendAgain]) {
        [[ZPPSmsVerificationManager shared] startTimer];
    }

    [self setButtonTextForTime:[ZPPSmsVerificationManager shared].currentTime];
    __weak typeof(self) weakSelf = self;
    [ZPPSmsVerificationManager shared].timerCounter = ^(NSInteger time) {

        [weakSelf setButtonTextForTime:time];
    };

    self.mainTF = self.codeTextField;
    self.bottomConstraint = self.bottomSuperviewConstraint;

    [self.codeTextField makeBordered];
    //    self.codeTextField.delegate = self;

    [self.againCodeButton addTarget:self
                             action:@selector(sendAgain)
                   forControlEvents:UIControlEventTouchUpInside];
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

- (void)setCode:(NSString *)code {
    _code = code;
}

#pragma mark - action

- (IBAction)submitCodeAction:(id)sender {
    if (![self checkCode]) {
        [self accentTextField:self.codeTextField];
        [self showWarningWithText:ZPPCodeWarningMessage];
    } else {
        [[ZPPSmsVerificationManager shared] invalidateTimer];
        [self performSegueWithIdentifier:ZPPShowRegistrationOtherScreenSegueIdentifier sender:nil];
    }
}

- (BOOL)checkCode {
    return [self.codeTextField.text isEqualToString:self.code];
    // return YES;
}

- (void)sendAgain {
    if (![[ZPPSmsVerificationManager shared] canSendAgain]) {
        return;
    }

    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [[ZPPSmsVerificationManager shared] POSTCode:self.code
        toNumber:self.user.phoneNumber
        onSuccess:^{
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self showSuccessWithText:@"Код отправлен"];
            [[ZPPSmsVerificationManager shared] startTimer];
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [self showWarningWithText:ZPPNoInternetConnectionMessage];
        }];
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

#pragma mark - support

- (void)setButtonTextForTime:(NSInteger)time {
    NSAttributedString *text;
    if (time != -1) {
        time = ZPPMaxCount - time;

        NSString *timeString = [NSString
            stringWithFormat:@"До повторной отправки %ld " @"секунд",
                             (long)time];

        text = [[NSAttributedString alloc] initWithString:timeString attributes:@{}];
    } else {
        NSDictionary *underlineAttribute =
            @{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
        text = [[NSAttributedString alloc] initWithString:@"Отправить повторно"
                                               attributes:underlineAttribute];
    }

    [self.againCodeButton setAttributedTitle:text forState:UIControlStateNormal];
}


@end
