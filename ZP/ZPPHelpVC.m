//
//  ZPPHelpVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPHelpVC.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import <MessageUI/MessageUI.h>

@interface ZPPHelpVC () <MFMailComposeViewControllerDelegate>

@end

@implementation ZPPHelpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.emailButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.emailButton.layer.borderWidth = 2.0f;
    self.phoneButton.layer.borderColor = [UIColor blackColor].CGColor;
    self.phoneButton.layer.borderWidth = 2.0f;

    [self.emailButton addTarget:self
                         action:@selector(sendEmail)
               forControlEvents:UIControlEventTouchUpInside];

    [self.phoneButton addTarget:self
                         action:@selector(makeCall)
               forControlEvents:UIControlEventTouchUpInside];

    //    [self.navigationController presentTransparentNavigationBar];
    //
    //    [self addCustomCloseButton];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];

    [self addCustomCloseButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
    switch (result) {
        case MFMailComposeResultSent:
            NSLog(@"You sent the email.");
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

#pragma mark - actions

- (void)sendEmail {
    if ([MFMailComposeViewController canSendMail]) {
        MFMailComposeViewController *mail = [[MFMailComposeViewController alloc] init];
        mail.mailComposeDelegate = self;
        [mail setSubject:@"Help"];
        //   [mail setMessageBody:@"Here is some main text in the email!" isHTML:NO];

        NSString *emailTo = self.emailButton.titleLabel.text;
        if (!emailTo) {
            return;
        }
        [mail setToRecipients:@[ emailTo ]];

        [self presentViewController:mail animated:YES completion:NULL];
    } else {
        NSLog(@"This device cannot send email");
    }
}

- (void)makeCall {
    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phoneButton.titleLabel.text];
    
    NSLog(@"%@", phoneNumber);

    if ([[UIApplication sharedApplication] canOpenURL : [NSURL URLWithString:phoneNumber ]]) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
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
