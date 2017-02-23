#import <MessageUI/MessageUI.h>
#import "UIButton+ZPPButtonCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPPromoVC.h"
#import "ZPPServerManager+ZPPPromoCodeManager.h"
#import "ZPPServerManager+ZPPRegistration.h"

#import "ZPPUserManager.h"

#import "ZPPCustomLabel.h"

#import "ZPPConsts.h"

static NSString *ZPPInviteSubject = @"Промокод \"Здоровое Питание\"";

@interface ZPPPromoVC () <MFMailComposeViewControllerDelegate,
    MFMessageComposeViewControllerDelegate,
    UITextFieldDelegate>

@property (strong, nonatomic) NSString *promocode;

@end

@implementation ZPPPromoVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self addCustomCloseButton];
  [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  //    self.bottomConstraint = self.bottomConstr;
  //    self.mainTF = self.codeTextField;

  self.bottomConstraint = self.additionalViewBottomConstraint;
  self.mainTF = self.smsInviteButton.superview;

  [self.codeTextField makeBordered];
  self.codeTextField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
  self.codeTextField.delegate = self;

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

                                           [[ZPPServerManager sharedManager] getCurrentUserOnSuccess:^(ZPPUser *user) {
                                                 [ZPPUserManager sharedInstance].user.balance = user.balance;
                                               }
                                                                                           onFailure:^(NSError *error, NSInteger statusCode) {
                                                                                           }];
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
    [self showWarningWithText:@"Устройство не поддерживает отправку смс"];
    return;
  }

  NSString *message = [self promocodeInviteText];

  MFMessageComposeViewController *messageController =
      [[MFMessageComposeViewController alloc] init];
  messageController.messageComposeDelegate = self;
  [messageController setBody:message];

  [self presentViewController:messageController animated:YES completion:nil];
}

#pragma mark - email

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(nullable NSError *)error {
  switch (result) {
    case MFMailComposeResultSent:
      [self showSuccessWithText:@"Сообщение отправлено"];
      break;
    case MFMailComposeResultSaved:
      break;
    case MFMailComposeResultCancelled:
      break;
    case MFMailComposeResultFailed:
      break;
    default:
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
    [self showWarningWithText:@"Устройство не поддерживает отправку e-mail"];
  }
}

#pragma mark - social

- (void)showSocialShare {
  NSString *string = [self promocodeInviteText];

  UIActivityViewController *activityViewController =
      [[UIActivityViewController alloc] initWithActivityItems:@[string]
                                        applicationActivities:nil];

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
                                        completion:nil];
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
      @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
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
  return
      [NSString stringWithFormat:
          @"Используй мой промокод, %@, и получи 300%@ в приложении Zdorovoe Pitanie! Скачай приложение по ссылке: http://onelink.to/2gfk9r",
          self.promocode, ZPPRoubleSymbol];  // redo
}

#pragma mark - keyboard

- (void)keyboardWillShow:(NSNotification *)aNotification {
  NSDictionary *info = [aNotification userInfo];
  CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;

  [self.view layoutIfNeeded];
  [UIView animateWithDuration:0.3
                   animations:^{
                     self.bottomConstraint.constant = -kbSize.height;
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

#pragma mark - text field delegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
  NSRange lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];

  if (lowercaseCharRange.location != NSNotFound) {
    textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                             withString:[string uppercaseString]];
    return NO;
  }

  return YES;
}


@end
