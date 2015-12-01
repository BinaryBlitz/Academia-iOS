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

#import "ZPPTimeManager.h"

@import SafariServices;

static NSString *ZPPOrderResultVCIdentifier = @"ZPPOrderResultVCIdentifier";

@interface ZPPOrderTimeChooserVC () <ZPPPaymentViewDelegate>
@property (strong, nonatomic) ZPPOrder *order;

@property (strong, nonatomic) ZPPOrder *paymentOrder;

@property (strong, nonatomic) UIImageView *checkMark;

@property (strong, nonatomic) NSString *alfaORderID;
@property (strong, nonatomic) NSString *bindingID;

@property (assign, nonatomic) BOOL once;

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

    //    if([ZPPTimeManager sharedManager].isOpen) {
    //        [self addCheckmarkToButton:self.nowButton];
    //    } else {
    //        self.nowButton.hidden = YES;
    //    }
}

- (void)viewDidLayoutSubviews {
    //    static BOOL
    //    [self addCheckmarkToButton:self.nowButton];
    if (!self.once) {
        self.once = YES;
        [self addCheckmarkToButton:self.nowButton];
    }
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
    [self.makeOrderButton startIndicatingWithType:UIActivityIndicatorViewStyleGray];
    [[ZPPServerManager sharedManager] POSTOrder:self.order
        onSuccess:^(ZPPOrder *ord) {
            //  [self.makeOrderButton stopIndication];
            // self.order = ord;

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
            [self.makeOrderButton stopIndication];

            [self showWarningWithText:@"Выберите другую область "
                                      @"доставки"];
        }];
}

- (void)didShowPageWithUrl:(NSURL *)url sender:(UIViewController *)vc {
    NSString *urlString = url.absoluteString;
    if ([urlString containsString:@"finish"]) {
        [[ZPPServerManager sharedManager] checkPaymentWithID:self.paymentOrder.identifier
            onSuccess:^(NSString *sta) {

                if ([sta isEqualToString:@"Успешно"]) {
                    [vc dismissViewControllerAnimated:YES
                                           completion:^{

                                           }];

                    UIViewController *vc = [self.storyboard
                        instantiateViewControllerWithIdentifier:ZPPOrderResultVCIdentifier];

                    [self.navigationController pushViewController:vc animated:YES];

                    [self.order clearOrder];
                }

            }
            onFailure:^(NSError *error, NSInteger statusCode){

            }];

        //        [vc dismissViewControllerAnimated:YES
        //                                        completion:^{
        //
        //                                        }];
    }
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

- (void)addTimePicker:(UIButton *)sender {
    NSMutableArray *arr = [NSMutableArray array];
    
    NSInteger currentHour = [[NSDate new] hour];
    NSInteger closeHour = 23;

    NSInteger time =
        currentHour > 11 && currentHour < closeHour ? currentHour : 11;

    for (int i = time; i < closeHour; i++) {
        NSString *timeString = [NSString stringWithFormat:@"%@:00 - %@:00", @(i), @(i + 1)];
        [arr addObject:timeString];
    }

    // NSArray *colors = [NSArray arrayWithObjects:@"Red", @"Green", @"Blue", @"Orange", nil];

    [ActionSheetStringPicker showPickerWithTitle:@"Выберите время"
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
