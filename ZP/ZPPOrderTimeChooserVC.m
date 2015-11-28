//
//  ZPPOrderTimeChooserVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTimeChooserVC.h"

#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIButton+ZPPButtonCategory.h"

#import "ZPPOrder.h"

#import "ZPPConsts.h"

#import <DateTools.h>
#import "RMDateSelectionViewController.h"

#import "NSDate+ZPPDateCategory.h"

//#import "ZPPPaymentManager.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"

#import "ZPPPaymentWebController.h"
#import "ZPPServerManager.h"

#import "ActionSheetPicker.h"

@import SafariServices;

static NSString *ZPPOrderResultVCIdentifier = @"ZPPOrderResultVCIdentifier";

@interface ZPPOrderTimeChooserVC () <ZPPPaymentViewDelegate>
@property (strong, nonatomic) ZPPOrder *order;
@property (strong, nonatomic) UIImageView *checkMark;

@property (strong, nonatomic) NSString *alfaORderID;
@property (strong, nonatomic) NSString *bindingID;

@end

@implementation ZPPOrderTimeChooserVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureButtons];

    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
}

- (void)viewWillAppear:(BOOL)animated {
    self.totalPriceLabel.text =
        [NSString stringWithFormat:@"ВАШ ЗАКАЗ НА: %@%@", @(self.order.totalPrice),
                                   ZPPRoubleSymbol];
}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.order = order;
}

- (void)makeOrderAction:(UIButton *)sender {
    [self startPayment];
}

- (void)orderNowAction:(UIButton *)sender {
    [self addCheckmarkToButton:sender];
    [self.atTimeButton setTitle:@"ВЫБРАТЬ ВРЕМЯ" forState:UIControlStateNormal];
}

- (void)orderAtTimeAction:(UIButton *)sender {
    //  [self showTimePicker];

    [self addTimePicker:sender];
}

- (void)configureButtons {
    [self.nowButton makeBordered];
    [self.atTimeButton makeBordered];
    [self.makeOrderButton makeBordered];

    [self.nowButton addTarget:self
                       action:@selector(orderNowAction:)
             forControlEvents:UIControlEventTouchUpInside];

    [self.atTimeButton addTarget:self
                          action:@selector(orderAtTimeAction:)
                forControlEvents:UIControlEventTouchUpInside];

    [self.makeOrderButton addTarget:self
                             action:@selector(makeOrderAction:)
                   forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - support

- (void)addCheckmarkToButton:(UIButton *)b {
    if ([b.subviews containsObject:self.checkMark]) {
        return;
    } else {
        [self.checkMark removeFromSuperview];
        [b addSubview:self.checkMark];
    }
}

#pragma mark - lazy

- (UIImageView *)checkMark {
    if (!_checkMark) {
        CGRect r = self.nowButton.frame;
        CGFloat leng = r.size.height / 2.0;

        UIImageView *iv = [[UIImageView alloc]
            initWithFrame:CGRectMake(r.size.width - leng * 1.5f, (r.size.height - leng) / 2.0, leng,
                                     leng)];
        iv.image = [UIImage imageNamed:@"checkMark"];

        _checkMark = iv;
    }

    return _checkMark;
}

#pragma mark - payment

- (void)startPayment {
    self.order.identifier = [NSString stringWithFormat:@"zpp_%u", arc4random() & 1000];

    [self.makeOrderButton startIndicating];
    [[ZPPServerManager sharedManager] POSTOrder:self.order onSuccess:^(ZPPOrder *order) {
        [self.makeOrderButton stopIndication];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [self.makeOrderButton stopIndication];
    }];
//    [[ZPPPaymentManager sharedManager] registrateOrder:self.order
//        onSuccess:^(NSURL *url, NSString *orderIDAlfa) {
//            [self.makeOrderButton stopIndication];
//
//            self.order.alfaNumber = orderIDAlfa;
//            [self showWebViewWithURl:url];
//
//        }
//        onFailure:^(NSError *error, NSInteger statusCode) {
//            [self.makeOrderButton stopIndication];
//
//            [self showWarningWithText:ZPPNoInternetConnectionMessage];
//        }];
}

- (void)didShowPageWithUrl:(NSURL *)url sender:(UIViewController *)vc {
    // https://test.paymentgate.ru/testpayment/merchants/zdorovoepitanie/finish.html?orderId=5cc56c99-4550-46be-a2fa-422a10f96040

//    NSString *destString = [NSString
//        stringWithFormat:@"%@/%@/%@?orderId=%@", [ZPPPaymentManager sharedManager].baseURL,
//                         ZPPCentralURL, ZPPPaymentFinishURL, self.order.alfaNumber];
//
//    NSLog(@"\n%@\n%@", url.absoluteString, destString);
//    if ([url.absoluteString isEqualToString:destString]) {
//        [vc dismissViewControllerAnimated:YES
//                               completion:^{
//
//                               }];
//
//        UIViewController *vc =
//            [self.storyboard instantiateViewControllerWithIdentifier:ZPPOrderResultVCIdentifier];
//
//        [self presentViewController:vc
//                           animated:YES
//                         completion:^{
//                             // [self dismissViewControllerAnimated:YES completion:nil];
//                         }];
//
//        //  [self ]
//    }
}

- (void)showWebViewWithURl:(NSURL *)url {
    ZPPPaymentWebController *wc = [[ZPPPaymentWebController alloc] init];
    [wc configureWithURL:url];
    wc.paymentDelegate = self;

    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:wc];

    //    [navC addCustomCloseButton];
    navC.navigationBar.barTintColor = [UIColor blackColor];

    [self presentViewController:navC animated:YES completion:nil];
}

- (void)checkOrderStatus {
}

#pragma mark - time shooser

- (void)showTimePicker {
    RMAction *selectAction = [RMAction
        actionWithTitle:@"Выбрать"
                  style:RMActionStyleDone
             andHandler:^(RMActionController *controller) {

                 NSDate *d = ((UIDatePicker *)controller.contentView).date;
                 NSLog(@"Successfully selected date: %@",
                       ((UIDatePicker *)controller.contentView).date);
                 NSString *dateStr = [NSString
                     stringWithFormat:
                         @"%@.%@ в ", @([d month]),
                         @([d day])];  //[d formattedDateWithStyle:NSDateFormatterShortStyle];

                 NSString *resString = [d timeStringfromDate];
                 resString = [dateStr stringByAppendingString:resString];
                 [self.atTimeButton setTitle:resString forState:UIControlStateNormal];
                 [self addCheckmarkToButton:self.atTimeButton];
             }];

    // Create cancel action
    RMAction *cancelAction = [RMAction actionWithTitle:@"Отменить"
                                                 style:RMActionStyleCancel
                                            andHandler:^(RMActionController *controller) {
                                                NSLog(@"Date selection was canceled");

                                            }];

    // Create date selection view controller
    RMDateSelectionViewController *dateSelectionController =
        [RMDateSelectionViewController actionControllerWithStyle:RMActionControllerStyleWhite
                                                    selectAction:selectAction
                                                 andCancelAction:cancelAction];

    dateSelectionController.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:30 * 60];
    dateSelectionController.datePicker.maximumDate =
        [NSDate dateWithTimeIntervalSinceNow:60 * 60 * 24 * 2];

    dateSelectionController.title = @"Выбор времени доставки";
    dateSelectionController.message = @"Когда вы хотите получить заказ?";

    RMAction *in90MinAction = [RMAction
        actionWithTitle:@"90 минут"
                  style:RMActionStyleAdditional
             andHandler:^(RMActionController *controller) {
                 ((UIDatePicker *)controller.contentView).date =
                     [NSDate dateWithTimeIntervalSinceNow:90 * 60];
                 NSLog(@"90 Min button tapped");

                 [self.atTimeButton setTitle:@"Через 90 минут" forState:UIControlStateNormal];
                 [self addCheckmarkToButton:self.atTimeButton];
             }];
    in90MinAction.dismissesActionController = YES;

    RMAction *in45MinAction = [RMAction
        actionWithTitle:@"45 минут"
                  style:RMActionStyleAdditional
             andHandler:^(RMActionController *controller) {
                 ((UIDatePicker *)controller.contentView).date =
                     [NSDate dateWithTimeIntervalSinceNow:45 * 60];
                 NSLog(@"45 Min button tapped");

                 [self.atTimeButton setTitle:@"Через 45 минут" forState:UIControlStateNormal];
                 [self addCheckmarkToButton:self.atTimeButton];

             }];
    in45MinAction.dismissesActionController = YES;

    RMAction *in60MinAction = [RMAction
        actionWithTitle:@"60 минут"
                  style:RMActionStyleAdditional
             andHandler:^(RMActionController *controller) {
                 ((UIDatePicker *)controller.contentView).date =
                     [NSDate dateWithTimeIntervalSinceNow:60 * 60];
                 NSLog(@"60 Min button tapped");
                 [self.atTimeButton setTitle:@"Через 60 минут" forState:UIControlStateNormal];
                 [self addCheckmarkToButton:self.atTimeButton];

             }];
    in60MinAction.dismissesActionController = YES;

    RMGroupedAction *groupedAction =
        [RMGroupedAction actionWithStyle:RMActionStyleAdditional
                              andActions:@[ in45MinAction, in60MinAction, in90MinAction ]];

    [dateSelectionController addAction:groupedAction];

    [self presentViewController:dateSelectionController animated:YES completion:nil];
}

- (void)addTimePicker:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray array];

    NSInteger time = [[NSDate new] hour] > 11 ? [[NSDate new] hour] : 11;

    for (int i = time; i < 24; i++) {
        NSString *timeString = [NSString stringWithFormat:@"%@:00 - %@:00", @(i), @(i + 1)];
        [arr addObject:timeString];
    }

    // NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];

    [ActionSheetStringPicker showPickerWithTitle:@"Select a Color"
        rows:[NSArray arrayWithArray:arr]
        initialSelection:0
        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            // NSLog(@"Picker: %@, Index: %ld, value: %@", picker, selectedIndex, selectedValue);

            [sender setTitle:selectedValue forState:UIControlStateNormal];
            [self addCheckmarkToButton:self.atTimeButton];
        }
        cancelBlock:^(ActionSheetStringPicker *picker) {
            NSLog(@"Block Picker Canceled");
        }
        origin:sender];
}

@end
