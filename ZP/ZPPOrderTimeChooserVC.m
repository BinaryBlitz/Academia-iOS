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
@import PureLayout;

#import <OAStackView/OAStackView.h>
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
#import "ZPPCreditCard.h"
#import "ZPPUserManager.h"

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

@implementation ZPPOrderTimeChooserVC {
    ZPPPaymentWebController *_webViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureButtons];

    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    
    self.totalPriceDetailsStackView.translatesAutoresizingMaskIntoConstraints = NO;
    self.totalPriceDetailsStackView.axis = UILayoutConstraintAxisVertical;
    self.totalPriceDetailsStackView.distribution = OAStackViewDistributionFillEqually;
    self.totalPriceDetailsStackView.alignment = OAStackViewAlignmentCenter;

    [Answers logCustomEventWithName:@"ORDER_TIME_CHOOSER_OPEN" customAttributes:@{}];
}

- (void)viewWillAppear:(BOOL)animated {
    for (UIView *view in self.totalPriceDetailsStackView.arrangedSubviews) {
        [self.totalPriceDetailsStackView removeArrangedSubview:view];
    }
  
    UIFont *font = [UIFont systemFontOfSize:17];
    
    CGFloat stackHeight = 0;
    CGFloat stackSpacing = 5;

    UILabel *totalPriceWithDeliveryLabel = [UILabel new];
    totalPriceWithDeliveryLabel.font = font;
    totalPriceWithDeliveryLabel.textAlignment = NSTextAlignmentCenter;
    totalPriceWithDeliveryLabel.text =
            [NSString stringWithFormat:@"Цена с доставкой: %ld%@", (long)[self.order totalPriceWithDelivery], ZPPRoubleSymbol];
    stackHeight += font.lineHeight + stackSpacing;
    [self.totalPriceDetailsStackView addArrangedSubview:totalPriceWithDeliveryLabel];
  
    ZPPUser *user = [ZPPUserManager sharedInstance].user;
    
    double price = [self.order totalPriceWithDelivery];
    if ([user.discount intValue] != 0) {
        double discount = (double)price * ([user.discount doubleValue] / 100.0);
        price -= discount;
        
        UILabel *discountLabel = [UILabel new];
        discountLabel.font = font;
        discountLabel.textAlignment = NSTextAlignmentCenter;
        discountLabel.text =
                [NSString stringWithFormat:@"Скидка: %d%@", (int)round(discount), ZPPRoubleSymbol];
        stackHeight += font.lineHeight + stackSpacing;
        [self.totalPriceDetailsStackView addArrangedSubview:discountLabel];
    }
    
    NSInteger balance;
    if ([user.balance intValue] > price) {
        balance = price;
    } else {
        balance = [user.balance integerValue];
    }
    
    if (balance > 0) {
        UILabel *balanceLabel = [UILabel new];
        balanceLabel.font = font;
        balanceLabel.textAlignment = NSTextAlignmentCenter;
        balanceLabel.text =
                    [NSString stringWithFormat:@"Бонусы: %ld%@", balance, ZPPRoubleSymbol];
        stackHeight += font.lineHeight + stackSpacing;
        [self.totalPriceDetailsStackView addArrangedSubview:balanceLabel];
    }
    
    [self.totalPriceDetailsStackView autoSetDimension:ALDimensionHeight toSize:stackHeight];
    
    self.totalPriceLabel.text =
                [NSString stringWithFormat:@"Итого: %ld%@", (long)[self.order totalPriceWithAllTheThings], ZPPRoubleSymbol];
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
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Оплата заказа"
                                                                       message:@"Вы уверены, что хотите оплатить заказ?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction: [UIAlertAction actionWithTitle:@"Да" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self startPayment];
        }]];
        [alert addAction: [UIAlertAction actionWithTitle:@"Нет" style:UIAlertActionStyleCancel handler:nil]];
        
        [self presentViewController:alert animated:YES completion:nil];
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
        onSuccess:^(ZPPOrder *order) {
            self.paymentOrder = order;
            
            if (self.order.card) {
                [[ZPPServerManager sharedManager] createNewPaymentWithOrderId:order.identifier
                    andBindingId:self.order.card.bindingId
                    onSuccess:^(NSString *paymentURLString) {
                        [self.makeOrderButton stopIndication];

                        [[ZPPServerManager sharedManager] processPaymentURLString:paymentURLString
                                onSuccess:^(NSString *redirectURLString) {
                                    if ([redirectURLString containsString:@"sakses"]) {
                                        [self pushSuccessOrderControllerWithAnimation];
                                    } else {
                                        [self showWarningWithText:@"Не удалось оплатить заказ"];
                                    }
                                } onFailure:^(NSError *error, NSInteger statusCode) {
                                    [self showWarningWithText:@"Не удалось оплатить заказ"];
                                }];
                    } onFailure:^(NSError *error, NSInteger statusCode) {
                        [self.makeOrderButton stopIndication];
                    }];
            } else {
                [[ZPPServerManager sharedManager] registerNewCreditCardOnSuccess:^(NSString *registrationURLString) {
                    [self.makeOrderButton stopIndication];

                    NSURL *url = [NSURL URLWithString:registrationURLString];
                    [self showWebViewWithURl:url];
                } onFailure:^(NSError *error, NSInteger statusCode) {
                    [self.makeOrderButton stopIndication];
                }];
            }
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
    
    if ([urlString containsString:@"sakses"]) {
        if (self.order.card == nil) {
            NSLog(@"new card");
            [self payWithNewCard];
        } else {
            [self presentSuccessOrderController];
        }
    } else if ([urlString containsString:@"feylur"]) {
        //smth
    }
}

- (void)payWithNewCard {
    [[ZPPServerManager sharedManager] listPaymentCardsWithSuccess:^(NSArray *cards) {
        ZPPCreditCard *card = cards.lastObject;
        if (card) {
            self.order.card = card;
            [[ZPPServerManager sharedManager] createNewPaymentWithOrderId:self.paymentOrder.identifier
                andBindingId:card.bindingId
                onSuccess:^(NSString *paymentURLString) {
                    NSURL *paymentURL  = [[NSURL alloc] initWithString:paymentURLString];
                    [self showWebViewWithURl:paymentURL];
                } onFailure:^(NSError *error, NSInteger statusCode) {
                    NSLog(@"¯\\_(ツ)_/¯");
                }];
        }
    } onFailure:^(NSError *error, NSInteger statusCode) {
        NSLog(@"(╯°□°）╯︵ ┻━┻ ");
        if (statusCode == 0) {
            [self payWithNewCard];
        }
    }];
}

- (void)presentSuccessOrderController {
    UIViewController *orderResultViewContorller = [self.storyboard
        instantiateViewControllerWithIdentifier:ZPPOrderResultVCIdentifier];

    [self.navigationController pushViewController:orderResultViewContorller animated:NO];
    self.paymentOrder = nil;
    [self.order clearOrder];
    [self dismissViewControllerAnimated: YES completion:nil];
}

- (void)pushSuccessOrderControllerWithAnimation {
    UIViewController *orderResultViewContorller = [self.storyboard
        instantiateViewControllerWithIdentifier:ZPPOrderResultVCIdentifier];

    [self.navigationController pushViewController:orderResultViewContorller animated:YES];
    self.paymentOrder = nil;
    [self.order clearOrder];
}

- (void)checkOrderSender:(UIViewController *)viewController {
    [[ZPPServerManager sharedManager] checkPaymentWithID:self.order.identifier
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
    _webViewController = [ZPPPaymentWebController new];
    [_webViewController configureWithURL:url];
    _webViewController.paymentDelegate = self;
    _webViewController.title = @"Оплата";
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:_webViewController];

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
                                                            message:@"Не удалось обновить доступное время доставки. Проверьте интернет соединение."
                                                     preferredStyle:UIAlertControllerStyleAlert];
                [alert addAction:[UIAlertAction actionWithTitle:@"OK"
                                                          style:UIAlertActionStyleDefault handler:nil]];
                [self presentViewController:alert animated:YES completion:nil];
            }];
}

- (void)showTimePickerWithTimeManager:(ZPPTimeManager *)timeManager forSender:(UIButton *)sender {
    
    NSArray *deliveryDates = [self deliveryDatesForTimeManager:timeManager];
    DTTimePeriod *lastTimePeriod = timeManager.openTimePeriodChain.lastObject;
    NSDate *closeDate = lastTimePeriod.EndDate;
    NSString *descrString;
    if ([[timeManager.currentTime dateByAddingMinutes:50 + 30] isEarlierThan:closeDate]) {
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
    NSDate *closeDate = lastTimePeriod.EndDate;
    if ([initialDate isLaterThan:closeDate]) {
        DTTimePeriod *firstTimePeriod = timeManager.openTimePeriodChain.firstObject;
        if ([firstTimePeriod.StartDate timeIntervalSinceDate:initialDate] > 50 * 60) {
            initialDate = firstTimePeriod.StartDate;
        } else {
            initialDate = [[firstTimePeriod StartDate] dateByAddingMinutes:50];
        }
    }
    
    initialDate = [initialDate dateBySubtractingSeconds:initialDate.second];
    
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
        
        
        for (int i = 0; i < [timeManager.openTimePeriodChain count]; i++) {
            DTTimePeriod *timePeriod = ((DTTimePeriod *)timeManager.openTimePeriodChain[i]).copy;
            if (i == 0) {
                timePeriod.StartDate = [timePeriod.StartDate dateByAddingMinutes:30];
            }
            if (i == [timeManager.openTimePeriodChain count] - 1) {
                timePeriod.EndDate = [timePeriod.EndDate dateByAddingMinutes:1];
            }
            
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
