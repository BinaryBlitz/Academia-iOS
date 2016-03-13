//
//  ZPPOrderTimeChooserVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTimeChooserVC.h"

#import "UIButton+ZPPButtonCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "ZPPOrder.h"

#import "ZPPConsts.h"

//#import <DateTools.h>
//#import "RMDateSelectionViewController.h"

#import "NSDate+ZPPDateCategory.h"

#import "ZPPNoInternetConnectionVC.h"

//#import "ZPPPaymentManager.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"

#import "ZPPPaymentWebController.h"
#import "ZPPServerManager.h"

#import "ActionSheetPicker.h"

#import "ZPPTimeManager.h"

#import <Crashlytics/Crashlytics.h>

@import SafariServices;
@import DateTools;

static NSString *ZPPOrderResultVCIdentifier = @"ZPPOrderResultVCIdentifier";

static NSString *ZPPNoInternetConnectionVCIdentifier = @"ZPPNoInternetConnectionVCIdentifier";

@interface ZPPOrderTimeChooserVC () <ZPPPaymentViewDelegate, ZPPNoInternetDelegate>
@property (strong, nonatomic) ZPPOrder *order;

@property (strong, nonatomic) ZPPOrder *paymentOrder;

@property (strong, nonatomic) UIImageView *checkMark;

@property (strong, nonatomic) NSString *alfaORderID;
@property (strong, nonatomic) NSString *bindingID;

@property (assign, nonatomic) BOOL once;

@property (strong, nonatomic) UIViewController *viewControllerToHide;

@end

@implementation ZPPOrderTimeChooserVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureButtons];

    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    [Answers logCustomEventWithName:@"ORDER_TIME_CHOOSER_OPEN" customAttributes:@{}];
}

- (void)viewWillAppear:(BOOL)animated {
    self.totalPriceLabel.text =
        [NSString stringWithFormat:@"ВАШ ЗАКАЗ НА: %@%@",
                                   @([self.order totalPriceWithDelivery]), ZPPRoubleSymbol];

    if ([self.order deliveryIncluded]) {
        self.deliveryLabel.text = [NSString stringWithFormat:@"+доставка 200%@", ZPPRoubleSymbol];
    } else {
        self.deliveryLabel.text = @"";
    }

    //    if (self.order.totalPrice < 1000) {
    //        self.deliveryLabel.text = [NSString stringWithFormat:@"+доставка 200%@",
    //        ZPPRoubleSymbol];
    //    } else {
    //        self.deliveryLabel.text = @"";
    //    }

    //    if([ZPPTimeManager sharedManager].isOpen) {
    //        [self addCheckmarkToButton:self.nowButton];
    //    } else {
    //        self.nowButton.hidden = YES;
    //    }
}

//- (void)viewWillDisappear:(BOOL)animated {
//    [super viewWillDisappear:animated];
//
////    self.order.date = nil;
//}

- (void)dealloc {
    self.order.date = nil;
}

- (void)viewDidLayoutSubviews {
    //    static BOOL
    //    [self addCheckmarkToButton:self.nowButton];
    if (!self.once) {
        if ([ZPPTimeManager sharedManager].isOpen) {
            self.once = YES;
            [self addCheckmarkToButton:self.nowButton];
            self.order.date = [[self class] nowByAppendingThirtyMinutes];
        } else {
            self.once = YES;
            self.nowButton.hidden = YES;
            self.order.date = nil;

            self.nowButtonHeight.constant = 0;
        }
    }
}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.order = order;
}

- (void)makeOrderAction:(UIButton *)sender {
    if (!self.order.date) {
        [self.atTimeButton shakeView];
        [self showWarningWithText:@"Выберите время доставки"];
    } else {
        [self startPayment];
    }
}

- (void)orderNowAction:(UIButton *)sender {
    [self addCheckmarkToButton:sender];
    self.order.date = [[self class] nowByAppendingThirtyMinutes];
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
    [self.makeOrderButton startIndicatingWithType:UIActivityIndicatorViewStyleGray];
    [[ZPPServerManager sharedManager] POSTOrder:self.order
        onSuccess:^(ZPPOrder *ord) {
            self.paymentOrder = ord;

            [[ZPPServerManager sharedManager] POSTPaymentWithOrderID:ord.identifier
                onSuccess:^(NSString *paymnetURL) {
                    [self.makeOrderButton stopIndication];

                    NSURL *url = [NSURL URLWithString:paymnetURL];
                    [self showWebViewWithURl:url];
                }
                onFailure:^(NSError *error, NSInteger statusCode) {
                    [self.makeOrderButton stopIndication];
                }];
        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            [self.makeOrderButton stopIndication];//redo

            
            [self showWarningWithText:@"Что-то пошло не так"];
        }];
}

- (void)didShowPageWithUrl:(NSURL *)url sender:(UIViewController *)vc {
    NSString *urlString = url.absoluteString;
//    NSLog(@"URL %@", urlString);
    if ([urlString containsString:@"finish"]) {
        [self checkOrderSender:vc];
    }
}

- (void)checkOrderSender:(UIViewController *)vc {
    [[ZPPServerManager sharedManager] checkPaymentWithID:self.paymentOrder.identifier
        onSuccess:^(NSString *sta) {

            if ([sta isEqualToString:@"Успешно"]) {
                [vc dismissViewControllerAnimated:YES
                                       completion:^{

                                       }];

                UIViewController *vc = [self.storyboard
                    instantiateViewControllerWithIdentifier:ZPPOrderResultVCIdentifier];

                [self.navigationController pushViewController:vc animated:YES];
                self.paymentOrder = nil;

                [self.order clearOrder];
            }

        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ZPPNoInternetConnectionVC *noInternetConnection =
                [sb instantiateViewControllerWithIdentifier:ZPPNoInternetConnectionVCIdentifier];
            noInternetConnection.noInternetDelegate = self;
            [vc presentViewController:noInternetConnection animated:YES completion:nil];
            self.viewControllerToHide = vc;

            //  [vc showNoInternetVC];

        }];
}

- (void)showWebViewWithURl:(NSURL *)url {
    ZPPPaymentWebController *wc = [[ZPPPaymentWebController alloc] init];
    [wc configureWithURL:url];
    wc.paymentDelegate = self;
    wc.title = @"Оплата";
    UINavigationController *navC = [[UINavigationController alloc] initWithRootViewController:wc];

    navC.navigationBar.barTintColor = [UIColor blackColor];

    [self presentViewController:navC animated:YES completion:nil];
}

- (void)tryAgainSender:(id)sender {
    [self checkOrderSender:self.viewControllerToHide];
}

#pragma mark - time shooser

- (void)addTimePicker:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *timeArr = [NSMutableArray array];

    NSDate *datee =
        [[self class] nowByAppendingThirtyMinutes];  //[NSDate dateWithYear:2015 month:12 day:1 hour:10 minute:59 second:13];
    NSInteger currentHour = [datee hour] + 1;  //[[NSDate new] hour] + 1 ;
    NSInteger closeHour = 23;
    NSInteger openHour = 11;

    NSInteger time = currentHour > openHour && currentHour < closeHour ? currentHour : openHour;

    for (int i = (int)time; i < closeHour; i++) {
        NSString *timeString = [NSString stringWithFormat:@"%@:00 - %@:00", @(i), @(i + 1)];
        [timeArr addObject:@(i)];
        [arr addObject:timeString];
    }

    BOOL tomorrow = currentHour >= closeHour;

    NSString *descrString;
    if (tomorrow) {
        descrString = @"Завтра в";
    } else {
        descrString = @"Сегодня в";
    }

    [ActionSheetStringPicker showPickerWithTitle:descrString
        rows:[NSArray arrayWithArray:arr]
        initialSelection:0
        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            // NSLog(@"Picker: %@, Index: %ld, value: %@", picker, selectedIndex, selectedValue);

            [sender setTitle:selectedValue forState:UIControlStateNormal];
            [self addCheckmarkToButton:self.atTimeButton];

            NSDate *d = datee;

            d = [d dateBySubtractingMinutes:[d minute]];
            NSInteger selectedHour = [timeArr[selectedIndex] integerValue];

            if (tomorrow) {
                d = [d dateByAddingHours:(24 - closeHour + selectedHour + 1)];
            } else {
                d = [d dateByAddingHours:(selectedHour - currentHour + 1)];
            }
            NSString *str = [d serverFormattedString];

            NSLog(@"date string %@", str);

            self.order.date = d;
        }
        cancelBlock:^(ActionSheetStringPicker *picker) {
//            NSLog(@"Block Picker Canceled");
        }
        origin:sender];
}

#pragma mark - date

+ (NSDate *)nowByAppendingThirtyMinutes {
    return [[NSDate new] dateByAddingMinutes:30];
}

@end
