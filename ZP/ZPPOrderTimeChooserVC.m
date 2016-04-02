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

static NSInteger closeHour = 23;

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
}

- (void)dealloc {
    self.order.date = nil;
}

- (void)viewDidLayoutSubviews {
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

- (void)addCheckmarkToButton:(UIButton *)button {
    if ([button.subviews containsObject:self.checkMark]) {
        return;
    } else {
        [self.checkMark removeFromSuperview];
        [button addSubview:self.checkMark];
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
            
            if (statusCode == 422) {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                                                         message:@"Неверное время  доставки. Проверьте настроки даты и времени"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"Настройки"
                                     style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * _Nonnull action) {
                                       NSURL *settingsURL = [[NSURL alloc] initWithString:@"prefs:root=General&path=DATE_AND_TIME"];
                                       if (settingsURL) {
                                           [[UIApplication sharedApplication] openURL:settingsURL];
                                       }
                }]];
                
                [alertController addAction:[UIAlertAction actionWithTitle:@"OK"
                                                                    style:UIAlertActionStyleDefault
                                                                  handler:nil]];
                
                [self presentViewController:alertController animated:YES completion:nil];
            } else if (statusCode == 0) {
                [self showWarningWithText:@"Проверьте соединение с интернетом"];
            } else {
                [self showWarningWithText:@"Что-то пошло не так. Попробуйте позже."];
            }
        }];
}

- (void)didShowPageWithUrl:(NSURL *)url sender:(UIViewController *)vc {
    NSString *urlString = url.absoluteString;
    NSLog(@"URL %@", urlString);
    if ([urlString containsString:@"finish"]) {
        [self checkOrderSender:vc];
    } else if ([urlString containsString:@"status"]) {
        NSLog(@"(╯°□°）╯︵ ┻━┻ ");
        [self checkOrderSender:vc];
    }
}

- (void)checkOrderSender:(UIViewController *)viewController {
    [[ZPPServerManager sharedManager] checkPaymentWithID:self.paymentOrder.identifier
        onSuccess:^(NSInteger sta) {
            
            if (sta == 2) {
                [viewController dismissViewControllerAnimated: YES completion:nil];

                UIViewController *orderResultViewContorller = [self.storyboard
                    instantiateViewControllerWithIdentifier:ZPPOrderResultVCIdentifier];

                [self.navigationController pushViewController:orderResultViewContorller animated:YES];
                self.paymentOrder = nil;

                [self.order clearOrder];
            }

        }
        onFailure:^(NSError *error, NSInteger statusCode) {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ZPPNoInternetConnectionVC *noInternetConnection =
                [sb instantiateViewControllerWithIdentifier:ZPPNoInternetConnectionVCIdentifier];
            noInternetConnection.noInternetDelegate = self;
            [viewController presentViewController:noInternetConnection animated:YES completion:nil];
            self.viewControllerToHide = viewController;
        }];
}

- (void)showWebViewWithURl:(NSURL *)url {
    ZPPPaymentWebController *webViewController = [ZPPPaymentWebController new];
    [webViewController configureWithURL:url];
    webViewController.paymentDelegate = self;
    webViewController.title = @"Оплата";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:webViewController];

    navigationController.navigationBar.barTintColor = [UIColor blackColor];

    [self presentViewController:navigationController animated:YES completion:nil];
}

- (void)tryAgainSender:(id)sender {
    [self checkOrderSender:self.viewControllerToHide];
}

#pragma mark - time shooser

- (void)addTimePicker:(UIButton *)sender {
    
    NSInteger openHour;
    if ([ZPPTimeManager sharedManager].openTime) {
        openHour = [[ZPPTimeManager sharedManager].openTime hour];
    } else {
        openHour = 11; //FIXME: set default open hour
    }
    
    NSArray *arr;
    NSDate *currentDate = [NSDate new];
    
    if (currentDate.hour >= closeHour || currentDate.hour < openHour) {
        arr = [self createPickerDateRowsStartedFromHour:openHour andMinute:0];
    } else {
        NSDate *deliveryDate = [currentDate dateByAddingMinutes:30];
        arr = [self createPickerDateRowsStartedFromHour:deliveryDate.hour andMinute:deliveryDate.minute];
    }

    BOOL tomorrow = currentDate.hour >= closeHour;

    NSString *descrString;
    if (tomorrow) {
        descrString = @"Завтра в";
    } else {
        descrString = @"Сегодня в";
    }

    [ActionSheetStringPicker showPickerWithTitle:descrString
        rows: arr
        initialSelection:0
        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            // NSLog(@"Picker: %@, Index: %ld, value: %@", picker, selectedIndex, selectedValue);

            [sender setTitle:selectedValue forState:UIControlStateNormal];
            [self addCheckmarkToButton:self.atTimeButton];

            NSDate *d = [[self class] nowByAppendingThirtyMinutes];
            d = [d dateBySubtractingMinutes:30];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            dateFormatter.dateFormat = @"hh:mm";
            NSString *selectedString = [(NSString *)selectedValue substringToIndex:5];
            NSDate *selectedDate = [dateFormatter dateFromString: selectedString];
            
            if (tomorrow) {
                d = [d dateByAddingHours: (24 - closeHour + selectedDate.hour)];
                d = [d dateByAddingMinutes: selectedDate.minute];
            } else {
                d = [d dateBySubtractingHours: d.hour];
                d = [d dateBySubtractingMinutes: d.minute];
                d = [d dateByAddingHours: selectedDate.hour];
                d = [d dateByAddingMinutes: selectedDate.minute];
            }
            
            NSLog(@"%@", d);
            NSString *str = [d serverFormattedString];
            NSLog(@"date string %@", str);

            self.order.date = d;
        }
        cancelBlock:^(ActionSheetStringPicker *picker) {
//            NSLog(@"Block Picker Canceled");
        }
        origin:sender];
}

- (NSArray *)createPickerDateRowsStartedFromHour: (NSInteger) hour andMinute: (NSInteger) minute {
    NSMutableArray *rows = [NSMutableArray array];
    
    int initialIndex;
    if (minute < 30) {
        initialIndex = (int)hour * 2 + 1;
    } else {
        hour += 1;
        initialIndex = (int)hour * 2;
    }
    
    for (int i = initialIndex; i < closeHour * 2 - 1; i++) {
        NSString *timeString;
        if (i % 2 == 0) {
            int currentHour = i / 2;
            timeString = [NSString stringWithFormat:@"%@:00 - %@:30", @(currentHour), @(currentHour)];
        } else {
            int currentHour = (i - 1) / 2;
            timeString = [NSString stringWithFormat:@"%@:30 - %@:00", @(currentHour), @(currentHour + 1)];
        }
        
        [rows addObject:timeString];
    }
    
    return [NSArray arrayWithArray:rows];
}

#pragma mark - date

+ (NSDate *)nowByAppendingThirtyMinutes {
    return [[NSDate new] dateByAddingMinutes:30];
}

@end
