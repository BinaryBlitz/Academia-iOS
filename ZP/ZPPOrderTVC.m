//
//  ZPPOrderTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 30/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTVC.h"

@import Crashlytics;
@import SafariServices;
#import "DTCustomColoredAccessory.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIButton+ZPPButtonCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"

#import "ZPPOrderItemCell.h"
#import "ZPPNoCreditCardCell.h"
#import "ZPPOrderTotalCell.h"
#import "ZPPOrderAddressCell.h"
#import "ZPPCreditCardInfoCell.h"
#import "ZPPCardInOrderCell.h"

#import "ZPPCardViewController.h"
#import "ZPPOrderItemVC.h"
#import "ZPPOrderResultVC.h"
#import "ZPPOrderTimeChooserVC.h"
#import "ZPPAdressVC.h"

#import "ZPPAddressDelegate.h"
#import "ZPPConsts.h"
#import "ZPPOrder.h"
#import "ZPPPaymentManager.h"

static NSString *ZPPOrderItemCellReuseIdentifier = @"ZPPOrderItemCellReuseIdentifier";
static NSString *ZPPNoCreditCardCellIdentifier = @"ZPPNoCreditCardCellIdentifier";
static NSString *ZPPOrderTotalCellIdentifier = @"ZPPOrderTotalCellIdentifier";
static NSString *ZPPOrderAddressCellIdentifier = @"ZPPOrderAddressCellIdentifier";
static NSString *ZPPCreditCardInfoCellIdentifier = @"ZPPCreditCardInfoCellIdentifier";
static NSString *ZPPCardInOrderCellIdentifier = @"ZPPCardInOrderCellIdentifier";

static NSString *ZPPCardViewControllerIdentifier = @"ZPPCardViewControllerIdentifier";
static NSString *ZPPOrderItemVCIdentifier = @"ZPPOrderItemVCIdentifier";
static NSString *ZPPAdressVCIdentifier = @"ZPPAdressVCIdentifier";
static NSString *ZPPOrderResultVCIdentifier = @"ZPPOrderResultVCIdentifier";
static NSString *ZPPOrderTimeChooserVCIdentifier = @"ZPPOrderTimeChooserVCIdentifier";

static NSString *ZPPNoAddresMessage = @"Выберите адрес доставки!";

@interface ZPPOrderTVC () <ZPPAddressDelegate>

@property (strong, nonatomic) ZPPOrder *order;

@end

@implementation ZPPOrderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registrateCells];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tintColor = [UIColor blackColor];
    
    
    [Answers logCustomEventWithName:@"ORDER_OPEN" customAttributes:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self setCustomNavigationBackButtonWithTransition];
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self.navigationController presentTransparentNavigationBar];

    [self addCustomCloseButton];

    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideIsNeeded];
}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.order = order;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 1) {
        return self.order.items.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == -1) {
//                if (!self.order.card) {
//                    ZPPNoCreditCardCell *cell =
//                        [tableView
//                        dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];
//                    [cell.actionButton setTitle:@"Выберите карту" forState:UIControlStateNormal];
//        
//                    [cell.actionButton addTarget:self
//                                          action:@selector(buttonsAction:)
//                                forControlEvents:UIControlEventTouchUpInside];
//                    return cell;
//                } else {
//                    ZPPCardInOrderCell *cell =
//                        [tableView
//                        dequeueReusableCellWithIdentifier:ZPPCreditCardInfoCellIdentifier];
//                    [cell configureWithCard:self.order.card];
//        
//                    [cell.chooseAnotherButton addTarget:self
//                                                 action:@selector(buttonsAction:)
//                                       forControlEvents:UIControlEventTouchUpInside];
//                    return cell;
//                }
//        return nil;
    } else if (indexPath.section == 0) {
        if (!self.order.address) {
            ZPPNoCreditCardCell *cell =
                [tableView dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];
            [cell.actionButton setTitle:@"Выберите адрес" forState:UIControlStateNormal];

            [cell.actionButton addTarget:self
                                  action:@selector(buttonsAction:)
                        forControlEvents:UIControlEventTouchUpInside];

            return cell;
        } else {
            ZPPOrderAddressCell *cell =
                [self.tableView dequeueReusableCellWithIdentifier:ZPPOrderAddressCellIdentifier];
            [cell configureWithAddress:self.order.address];

            [cell.chooseAnotherButton addTarget:self
                                         action:@selector(buttonsAction:)
                               forControlEvents:UIControlEventTouchUpInside];
            return cell;
        }

    } else if (indexPath.section == 2) {
        ZPPOrderTotalCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPOrderTotalCellIdentifier];

        [cell configureWithOrder:self.order];

        return cell;

    } else if (indexPath.section == 3) {
        ZPPNoCreditCardCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];
        [cell.actionButton setTitle:@"Заказать" forState:UIControlStateNormal];

        [cell.actionButton addTarget:self
                              action:@selector(buttonsAction:)
                    forControlEvents:UIControlEventTouchUpInside];

        return cell;

    } else {
        ZPPOrderItem *orderItem = self.order.items[indexPath.row];

        ZPPOrderItemCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPOrderItemCellReuseIdentifier];
        [cell configureWithOrderItem:orderItem];

        DTCustomColoredAccessory *accessory =
            [DTCustomColoredAccessory accessoryWithColor:cell.countLabel.textColor];
        accessory.highlightedColor = [UIColor blackColor];
        cell.accessoryView = accessory;

        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2) {
        return 100.f;
    } else if (indexPath.section != 1) {
        if (indexPath.section == 0 && self.order.address) {
            return 110.0;
        }

        return 60.f;
    } else {
        return 50.f;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        ZPPOrderItem *orderItem = self.order.items[indexPath.row];

        [self showItemModifier:orderItem];
    }
}

#pragma mark - actions

- (void)buttonsAction:(UIButton *)sender {
    UITableViewCell *cell = [self parentCellForView:sender];
    if (cell) {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];
        if (ip.section == -1) {
            [self showCardChooser];
        } else if (ip.section == 0) {
            [self showMap];
        } else if (ip.section == 3) {
            [self showResultScreenSender:sender];
        }
    }
}

- (void)showCardChooser {
    ZPPCardViewController *cardVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPCardViewControllerIdentifier];

    cardVC.cardDelegate = self;

    [self.navigationController pushViewController:cardVC animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showMap {
    ZPPAdressVC *adressVC = [self.storyboard instantiateViewControllerWithIdentifier:ZPPAdressVCIdentifier];
    adressVC.addressDelegate = self;

    [self.navigationController pushViewController:adressVC animated:YES];
}

- (void)showItemModifier:(ZPPOrderItem *)orderItem {
    ZPPOrderItemVC *orderVC = [self.storyboard instantiateViewControllerWithIdentifier:ZPPOrderItemVCIdentifier];
    [orderVC configureWithOrder:self.order item:orderItem];
    [self.navigationController pushViewController:orderVC animated:YES];
}

- (void)hideIsNeeded {
    if (self.order.items.count <= 0) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showResultScreenSender:(UIButton *)sender {
    
    if (!self.order.address) {
        [self showWarningWithText: ZPPNoAddresMessage];
        NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
        ZPPNoCreditCardCell *cell = [self.tableView cellForRowAtIndexPath:ip];
        
        if (cell && [cell isKindOfClass:[ZPPNoCreditCardCell class]]) {
            [cell.actionButton shakeView];
        }
        
        return;
    }
    
    ZPPOrderTimeChooserVC *orvc = [self resultScreen];
    [orvc configureWithOrder:self.order];
    [self.navigationController pushViewController:orvc animated:YES];
}

#pragma mark - ZPPAddressDelegate

- (void)configureWithAddress:(ZPPAddress *)address sender:(id)sender {
    self.order.address = address;
    [self.tableView reloadData];
}

#pragma mark - Support

- (void)registrateCells {
    [self registrateCellForClass:[ZPPOrderItemCell class]
                 reuseIdentifier:ZPPOrderItemCellReuseIdentifier];
    [self registrateCellForClass:[ZPPNoCreditCardCell class]
                 reuseIdentifier:ZPPNoCreditCardCellIdentifier];
    [self registrateCellForClass:[ZPPOrderTotalCell class]
                 reuseIdentifier:ZPPOrderTotalCellIdentifier];
    [self registrateCellForClass:[ZPPOrderAddressCell class]
                 reuseIdentifier:ZPPOrderAddressCellIdentifier];
        [self registrateCellForClass:[ZPPCreditCardInfoCell class]
                     reuseIdentifier:ZPPCreditCardInfoCellIdentifier];
        [self registrateCellForClass:[ZPPCardInOrderCell class]
                     reuseIdentifier:ZPPCreditCardInfoCellIdentifier];
}

- (ZPPOrderTimeChooserVC *)resultScreen {
    ZPPOrderTimeChooserVC *orvc =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPOrderTimeChooserVCIdentifier];
    return orvc;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
