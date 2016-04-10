//
//  ZPPOrderTimeChooserVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTimeChooserVC.h"

@import ActionSheetPicker_3_0;
@import Crashlytics;
@import SafariServices;
@import DateTools;

#import "UIButton+ZPPButtonCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "ZPPOrder.h"
#import "ZPPConsts.h"
#import "NSDate+ZPPDateCategory.h"
#import "ZPPNoInternetConnectionVC.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"
#import "ZPPPaymentWebController.h"
#import "ZPPServerManager.h"
#import "ZPPTimeManager.h"

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
}

- (void)dealloc {
    self.order.date = nil;
}

- (void)viewDidLayoutSubviews {
    if (!self.once) {
        if ([ZPPTimeManager sharedManager].isOpen) {
            self.once = YES;
            [self addCheckmarkToButton:self.nowButton];
            self.order.date = [[ZPPTimeManager sharedManager].currentTime dateByAddingMinutes:50];
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
    self.order.deliverNow = YES;
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
                                                                                         message:@"Недопустимое время доставки. Попробуйте ещё раз"
                                                                                  preferredStyle:UIAlertControllerStyleAlert];
                
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
                UIViewController *orderResultViewContorller = [self.storyboard
                    instantiateViewControllerWithIdentifier:ZPPOrderResultVCIdentifier];

                [self.navigationController pushViewController:orderResultViewContorller animated:NO];
                self.paymentOrder = nil;

                [self.order clearOrder];
                [viewController dismissViewControllerAnimated: YES completion:nil];

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
    [[ZPPServerManager sharedManager]
            getWorkingHours:^(ZPPTimeManager *timeManager) {
                [self showTimePickerWithTimeManager:timeManager forSender:sender];
            } onFailure:^(NSError *error, NSInteger statusCode) {
                UIAlertController *alert =
                        [UIAlertController alertControllerWithTitle:@"Ошибка"
                                                            message:@"Не удалось обновить доступное вермя доставки. Проверьте интернет соединение."
                                                     preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }];
}

- (void)showTimePickerWithTimeManager:(ZPPTimeManager *)timeManager forSender:(UIButton *)sender {
    
    NSArray *deliveryDates = [self deliveryDatesForTimeManager:timeManager];
    DTTimePeriod *lastTimePeriod = timeManager.openTimePeriodChain.lastObject;
    NSDate *closeDate = [lastTimePeriod.EndDate dateBySubtractingMinutes:30];
    NSString *descrString;
    if ([[timeManager.currentTime dateByAddingMinutes:50] isEarlierThan:closeDate]) {
        descrString = @"Сегодня в";
    } else {
        descrString = @"Завтра в";
    }
    NSMutableArray *keys = [NSMutableArray array];
    for (DTTimePeriod *tp in deliveryDates) {
        NSDateFormatter *formatter = [NSDateFormatter new];
        formatter.dateFormat = @"HH:mm";
        NSString *key = [NSString stringWithFormat:@"%@ - %@",
                         [formatter stringFromDate:tp.StartDate],
                         [formatter stringFromDate:tp.EndDate] ];
        [keys addObject:key];
    }

    [ActionSheetStringPicker showPickerWithTitle:descrString
        rows:keys
        initialSelection:0
        doneBlock:^(ActionSheetStringPicker *picker, NSInteger selectedIndex, id selectedValue) {
            self.order.deliverNow = NO;
            [sender setTitle:selectedValue forState:UIControlStateNormal];
            [self addCheckmarkToButton:self.atTimeButton];
            
            NSDate *selectedDate = ((DTTimePeriod *)[deliveryDates objectAtIndex:selectedIndex]).StartDate;
            if ([timeManager.currentTime isEarlierThan:closeDate]) {
                self.order.date = selectedDate;
            } else {
                self.order.date = [selectedDate dateByAddingDays:1];
            }
            NSLog(@"selected date: %@", self.order.date);
        }
        cancelBlock:nil
        origin:sender];
}

- (NSArray *)deliveryDatesForTimeManager:(ZPPTimeManager *)timeManager {
    NSMutableArray *deliveryDates = [NSMutableArray array];
    
    NSDate *initialDate = [timeManager.currentTime dateByAddingMinutes:50];
    DTTimePeriod *lastTimePeriod = timeManager.openTimePeriodChain.lastObject;
    NSDate *closeDate = [lastTimePeriod.EndDate dateBySubtractingMinutes:30];
    
    if ([initialDate isLaterThan:closeDate]) {
        DTTimePeriod *firstTimePeriod = timeManager.openTimePeriodChain.firstObject;
        initialDate = [[firstTimePeriod StartDate] dateByAddingMinutes:50];
    }
    
    if ([initialDate minute] < 30) {
        NSInteger minute = [initialDate minute];
        initialDate = [initialDate dateByAddingMinutes:30 - minute];
    } else if ([initialDate minute] > 30) {
        NSInteger minute = [initialDate minute];
        initialDate = [initialDate dateByAddingMinutes:60 - minute];
    }
    
    while ([initialDate isEarlierThan: closeDate]) {
        BOOL validDevliveryDate = false;
        DTTimePeriod *deliveryPeriod = [DTTimePeriod timePeriodWithStartDate:initialDate
                                                                     endDate:[initialDate dateByAddingMinutes:30]];
        
        for (DTTimePeriod *timePeriod in timeManager.openTimePeriodChain) {
            if ([deliveryPeriod isInside:timePeriod]) {
                validDevliveryDate = true;
                break;
            }
        }
        
        if (validDevliveryDate) {
            [deliveryDates addObject:deliveryPeriod];
        }
        
        initialDate = deliveryPeriod.EndDate;
    }
    
    return [NSArray arrayWithArray:deliveryDates];
}

@end
