//
//  ZPPPromoVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPromoVC.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIButton+ZPPButtonCategory.h"
#import "UIView+UIViewCategory.h"
#import "ZPPServerManager+ZPPPromoCodeManager.h"
#import "ZPPServerManager+ZPPRegistration.h"
#import <MessageUI/MessageUI.h>

#import "ZPPUserManager.h"

#import "ZPPCustomLabel.h"

#import "ZPPConsts.h"

static NSString *ZPPInviteSubject = @"Промокод \"Здоровое Питание\"";

@interface ZPPPromoVC () <MFMailComposeViewControllerDelegate,
                          MFMessageComposeViewControllerDelegate>

@property (strong, nonatomic) NSString *promocode;

@end

@implementation ZPPPromoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.bottomConstraint = self.bottomConstr;
    self.mainTF = self.codeTextField;

    [self.codeTextField makeBordered];

    [self.doneButton addTarget:self
                        action:@selector(confirmCode:)
              forControlEvents:UIControlEventTouchUpInside];

    self.promocode = [ZPPUserManager sharedInstance].user.promoCode;

    if (!self.promocode || [self.promocode isEqual:[NSNull null]]) {
        self.promocodeLabel.hidden = YES;
        self.smsInviteButton.hidden = YES;
        self.emailShare.hidden = YES;
        self.socialMediaShare.hidden = YES;
    } else {
        //    self.promocode = @"code123";

        [self configureLabelWithCode:self.promocode];
        [self configureButtons];
        [self configureKeyboardClose];
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];

    //    [[ZPPServerManager sharedManager] getCurrentUserOnSuccess:^(ZPPUser *user) {
    //
    //    } onFailure:^(NSError *error, NSInteger statusCode){
    //
    //    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma marl - actions

- (void)confirmCode:(UIButton *)sender {
    if (![self checkPromoCodeTextField:self.codeTextField]) {
        [self accentTextField:self.codeTextField];
        [self showWarningWithText:ZPPPromoCodeErrorMessage];
        return;
    }

    [sender startIndicating];

    [[ZPPServerManager sharedManager] POSTPromocCode:self.codeTextField.text
        onSuccess:^{
            [sender stopIndication];
            [self showSuccessWithText:@"Код добавлен"];

            self.codeTextField.text = @"";
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [sender stopIndication];
            [self showWarningWithText:ZPPWrongCardNumber];
        }];
}
#pragma mark - sms

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller
                 didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
        case MessageComposeResultCancelled:
            break;

        case MessageComposeResultFailed: {
            //            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error"
            //            message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK"
            //            otherButtonTitles:nil];
            //            [warningAlert show];
            break;
        }

        case MessageComposeResultSent:
            break;

        default:
            break;
    }

    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)showSmsInput {
    if (![MFMessageComposeViewController canSendText]) {
        //        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error"
        //        message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK"
        //        otherButtonTitles:nil];
        //        [warningAlert show];
        [self showWarningWithText:@"Устройство не поддерживает "
              @"отпра" @"в" @"к" @"у" @" " @"смс"];
        return;
    }

    // NSArray *recipents = @[];
    NSString *message = [self promocodeInviteText];

    MFMessageComposeViewController *messageController =
        [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    //   [messageController setRecipients:recipents];
    [messageController setBody:message];

    // Present message view controller on screen
    [self presentViewController:messageController animated:YES completion:nil];
}

#pragma mark - email

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
            [self showSuccessWithText:@"Сообщение отправлено"];
            break;
        case MFMailComposeResultSaved:
            NSLog(@"You saved a draft of this email");
            break;
        case MFMailComposeResultCancelled:
            NSLog(@"You cancelled sending this email.");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
            break;
        default:
            NSLog(@"An error occurred when trying to compose this email");
            break;
    }

    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showEmailInput {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:ZPPInviteSubject];
        [mail setMessageBody:[self promocodeInviteText] isHTML:NO];

        [mail setToRecipients:@[]];

        [self presentViewController:mail animated:YES completion:NULL];
    } else {
        [self showWarningWithText:@"Устройство не поддерживает "
              @"отправ" @"к" @"у" @" " @"e-mail"];
    }
}
#pragma mark - social

- (void)showSocialShare {
    NSString *string = [self promocodeInviteText];
    //  NSURL *URL = ...;

    UIActivityViewController *activityViewController =
        [[UIActivityViewController alloc] initWithActivityItems:@[ string ]
                                          applicationActivities:nil];
    //    activityViewController.

    activityViewController.excludedActivityTypes = @[
        UIActivityTypeMessage,
        UIActivityTypeMail,
        UIActivityTypePrint,
        UIActivityTypeCopyToPasteboard,
        UIActivityTypeAssignToContact,
        UIActivityTypeSaveToCameraRoll,
        UIActivityTypeAddToReadingList,
        UIActivityTypePostToVimeo,
        UIActivityTypePostToTencentWeibo,
        UIActivityTypeAirDrop,
        UIActivityTypeOpenInIBooks
    ];

    [self.navigationController presentViewController:activityViewController
                                            animated:YES
                                          completion:^{
                                              // ...
                                          }];
}

#pragma mark - copy
- (void)showResponder:(UIGestureRecognizer *)sender {
    UIView *v = sender.view;

    UIMenuController *mc = [UIMenuController sharedMenuController];
    [mc setTargetRect:v.frame inView:v.superview];

    [mc setMenuVisible:YES animated:YES];

    [v becomeFirstResponder];
}

#pragma mark - support

#pragma mark - ui

- (void)configureLabelWithCode:(NSString *)code {
    self.promocodeLabel.text = code;
    self.promocodeLabel.userInteractionEnabled = YES;

    UITapGestureRecognizer *tgr =
        [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showResponder:)];

    tgr.numberOfTapsRequired = 1;
    tgr.numberOfTouchesRequired = 1;

    [self.promocodeLabel addGestureRecognizer:tgr];
}

- (void)configureButtons {
    [self.smsInviteButton makeBordered];
    [self.emailShare makeBordered];
    //  [self.socialMediaShare makeBordered];

    [self.smsInviteButton addTarget:self
                             action:@selector(showSmsInput)
                   forControlEvents:UIControlEventTouchUpInside];

    [self.emailShare addTarget:self
                        action:@selector(showEmailInput)
              forControlEvents:UIControlEventTouchUpInside];

    [self.socialMediaShare addTarget:self
                              action:@selector(showSocialShare)
                    forControlEvents:UIControlEventTouchUpInside];

    NSDictionary *underlineAttribute =
        @{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
    NSAttributedString *attrStr =
        [[NSAttributedString alloc] initWithString:self.socialMediaShare.titleLabel.text
                                        attributes:underlineAttribute];

    [self.socialMediaShare setAttributedTitle:attrStr forState:UIControlStateNormal];
}

- (void)configureKeyboardClose {
    UITapGestureRecognizer *tgr =
        [[UITapGestureRecognizer alloc] initWithTarget:self.codeTextField
                                                action:@selector(resignFirstResponder)];

    tgr.numberOfTapsRequired = 1;
    tgr.numberOfTouchesRequired = 1;

    [self.view addGestureRecognizer:tgr];
}

- (NSString *)promocodeInviteText {
    return [NSString stringWithFormat:@"Промокод %@ ага", self.promocode];  // redo
}

@end
