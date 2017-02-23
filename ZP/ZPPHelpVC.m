//
//  ZPPHelpVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 27/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPConsts.h"
#import "ZPPHelpVC.h"
#import "ZPPPaymentWebController.h"
#import "ZPPRulesVC.h"

#import <MessageUI/MessageUI.h>

@interface ZPPHelpVC () <MFMailComposeViewControllerDelegate>

@end

@implementation ZPPHelpVC

- (void)viewDidLoad {
  [super viewDidLoad];
  // Do any additional setup after loading the view.

  [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  NSDictionary *underlineAttribute = @{
      NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.f]
  };
  NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.phoneTextView.text
                                                                attributes:underlineAttribute];

  self.phoneTextView.attributedText = attrStr;
  self.phoneTextView.textAlignment = NSTextAlignmentCenter;

  [self.emailButton makeBordered];
  [self.phoneTextView makeBordered];

  [self.emailButton addTarget:self
                       action:@selector(sendEmail)
             forControlEvents:UIControlEventTouchUpInside];

  [self.rulesButton addTarget:self
                       action:@selector(showRules)
             forControlEvents:UIControlEventTouchUpInside];
  [self.legalButon addTarget:self
                      action:@selector(showLegal)
            forControlEvents:UIControlEventTouchUpInside];

  NSDictionary *undatr = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
  NSAttributedString *atrstr =
      [[NSAttributedString alloc] initWithString:@"Правила использования"
                                      attributes:undatr];

  NSAttributedString *legalText =
      [[NSAttributedString alloc] initWithString:@"Реквизиты" attributes:undatr];

  self.rulesButton.titleLabel.minimumScaleFactor = 0.5;
  self.rulesButton.titleLabel.adjustsFontSizeToFitWidth = YES;

  [self.rulesButton setAttributedTitle:atrstr forState:UIControlStateNormal];

  self.legalButon.titleLabel.minimumScaleFactor = 0.5;
  self.legalButon.titleLabel.adjustsFontSizeToFitWidth = YES;

  [self.legalButon setAttributedTitle:legalText forState:UIControlStateNormal];
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
//            NSLog(@"You sent the email.");
      break;
    case MFMailComposeResultSaved:
//            NSLog(@"You saved a draft of this email");
      break;
    case MFMailComposeResultCancelled:
      // NSLog(@"You cancelled sending this email.");
      break;
    case MFMailComposeResultFailed:
//            NSLog(@"Mail failed:  An error occurred when trying to compose this email");
      break;
    default:
//            NSLog(@"An error occurred when trying to compose this email");
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
    [mail setToRecipients:@[emailTo]];

    [self presentViewController:mail animated:YES completion:NULL];
  } else {
    NSLog(@"This device cannot send email");
  }
}

#pragma mark - rules

- (void)showRules {
  ZPPPaymentWebController *wc = [[ZPPPaymentWebController alloc] init];

//    encodedSelectedWord = [selectedWord stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
  NSString *urlString = [ZPPRulesURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//[ZPPRulesURL stringByAddingPercentEncodingWithAllowedCharacters:URLQueryAllowedCharacterSet];
  NSURL *url = [NSURL URLWithString:urlString];

  wc.title = @"Правила";
  [wc configureWithURL:url];
  //    wc.paymentDelegate = self;

  UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:wc];

  navC.navigationBar.barTintColor = [UIColor blackColor];

  [self presentViewController:navC animated:YES completion:nil];
  //    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"registration" bundle:nil];
  //    ZPPRulesVC *vc = [sb instantiateViewControllerWithIdentifier:ZPPRulesVCID];
  //    //    UINavigationController *nav = vc.navigationController;
  //    UINavigationController *nav = [[UINavigationController alloc]
  //    initWithRootViewController:vc];
  //
  //    [self presentViewController:nav animated:YES completion:nil];
}

- (void)showLegal {
  UIStoryboard *sb = [UIStoryboard storyboardWithName:@"registration" bundle:nil];
  ZPPRulesVC *vc = [sb instantiateViewControllerWithIdentifier:ZPPRulesVCID];
  vc.title = @"Реквизиты";
  UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:vc];
  [self presentViewController:nav animated:YES completion:nil];
}

//- (void)makeCall {
//    NSString *phoneNumber = [@"tel://" stringByAppendingString:self.phoneButton.titleLabel.text];
//
//    NSLog(@"%@", phoneNumber);
//
//    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:phoneNumber]]) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
//    }
//}
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
