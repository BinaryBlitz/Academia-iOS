//
//  ZPPOrderTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 30/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTVC.h"

@import Crashlytics;
@import PureLayout;
#import "DTCustomColoredAccessory.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"

#import "ZPPOrderItemCell.h"
#import "ZPPNoCreditCardCell.h"
#import "ZPPOrderTotalCell.h"
#import "ZPPOrderAddressCell.h"
#import "ZPPCreditCardInfoCell.h"

#import "ZPPOrderItemVC.h"
#import "ZPPOrderTimeChooserVC.h"
#import "ZPPAdressVC.h"

#import "ZPPConsts.h"
#import "ZPPOrder.h"
#import "ZPPCreditCard.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"

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

@implementation ZPPOrderTVC {
  NSArray *_creditCards;
  int _selectedCardIndex;
}

- (void)viewDidLoad {
  [super viewDidLoad];
  [self registrateCells];
  [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
  [self setNeedsStatusBarAppearanceUpdate];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tintColor = [UIColor blackColor];
  self.tableView.sectionFooterHeight = 0.01;

  _creditCards = @[];
  _selectedCardIndex = 0;

  [[ZPPServerManager sharedManager] listPaymentCardsWithSuccess:^(NSArray *cards) {
    _creditCards = cards;
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:1] withRowAnimation:UITableViewRowAnimationFade];
  }                                                   onFailure:^(NSError *error, NSInteger statusCode) {
    [self showWarningWithText:@"Не удалось загрузить привязанные карты ;("];
  }];

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
  return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  switch (section) {
    case 1:
      return _creditCards.count > 0 ? _creditCards.count + 1 : 0;
      break;
    case 2:
      return self.order.items.count;
      break;
    default:
      return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
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
  } else if (indexPath.section == 1) {
    ZPPCreditCardInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPCreditCardInfoCellIdentifier];
    if (indexPath.row == _creditCards.count) {
      [cell.cardNumberLabel setText:@"Новая карта"];
    } else {
      ZPPCreditCard *card = _creditCards[indexPath.row];
      [cell.cardNumberLabel setText:card.number];
    }

    if (indexPath.row == _selectedCardIndex) {
      cell.checkmarkImageView.hidden = NO;
    } else {
      cell.checkmarkImageView.hidden = YES;
    }

    return cell;
  } else if (indexPath.section == 2) {
    ZPPOrderItem *orderItem = self.order.items[indexPath.row];

    ZPPOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPOrderItemCellReuseIdentifier];
    [cell configureWithOrderItem:orderItem];

    DTCustomColoredAccessory *accessory =
        [DTCustomColoredAccessory accessoryWithColor:cell.countLabel.textColor];
    accessory.highlightedColor = [UIColor blackColor];
    cell.accessoryView = accessory;

    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    return cell;
  } else if (indexPath.section == 3) {
    ZPPOrderTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPOrderTotalCellIdentifier];

    [cell configureWithOrder:self.order];

    return cell;
  } else if (indexPath.section == 4) {
    ZPPNoCreditCardCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];
    [cell.actionButton setTitle:@"Заказать" forState:UIControlStateNormal];

    [cell.actionButton addTarget:self
                          action:@selector(buttonsAction:)
                forControlEvents:UIControlEventTouchUpInside];

    return cell;
  } else {
    return [UITableViewCell new];
  }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return self.order.address ? 110.0 : 60.f;
  } else if (indexPath.section == 1) {
    return 46.f;
  } else if (indexPath.section == 3) {
    return 100.f;
  } else {
    return 50.f;
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 1 && _selectedCardIndex != indexPath.row) {
    ZPPCreditCardInfoCell *selectedCell = [tableView cellForRowAtIndexPath:
        [NSIndexPath indexPathForRow:_selectedCardIndex inSection:1]];
    selectedCell.checkmarkImageView.hidden = YES;
    ZPPCreditCardInfoCell *cellToSelect = [tableView cellForRowAtIndexPath:indexPath];
    cellToSelect.checkmarkImageView.hidden = NO;
    _selectedCardIndex = (int) indexPath.row;
  } else if (indexPath.section == 2) {
    ZPPOrderItem *orderItem = self.order.items[indexPath.row];

    [self showItemModifier:orderItem];
  }

  [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
  if (section == 1) {
    UIView *sectionTitleView = [UIView new];
    UILabel *title = [UILabel new];
    title.text = @"Выбор карты";
    title.textAlignment = NSTextAlignmentCenter;
    title.font = [UIFont systemFontOfSize:21];
    [sectionTitleView addSubview:title];
    [title autoPinEdgesToSuperviewEdges];

    return sectionTitleView;
  }

  return [tableView headerViewForSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
  if (section == 1 && _creditCards.count != 0) {
    return 30.0;
  }
  return 0.01;
}

#pragma mark - actions

- (void)buttonsAction:(UIButton *)sender {
  UITableViewCell *cell = [self parentCellForView:sender];
  if (cell) {
    NSIndexPath *ip = [self.tableView indexPathForCell:cell];
    if (ip.section == 0) {
      [self showMap];
    } else if (ip.section == 4) {
      [self showResultScreenSender:sender];
    }
  }
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
    [self showWarningWithText:ZPPNoAddresMessage];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
    ZPPNoCreditCardCell *cell = [self.tableView cellForRowAtIndexPath:ip];

    if (cell && [cell isKindOfClass:[ZPPNoCreditCardCell class]]) {
      [cell.actionButton shakeView];
    }

    return;
  }

  if (_creditCards.count != 0 && _selectedCardIndex < _creditCards.count) {
    self.order.card = _creditCards[_selectedCardIndex];
  } else {
    self.order.card = nil;
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
  [self registrateCellForClass:[ZPPOrderItemCell class] reuseIdentifier:ZPPOrderItemCellReuseIdentifier];
  [self registrateCellForClass:[ZPPNoCreditCardCell class] reuseIdentifier:ZPPNoCreditCardCellIdentifier];
  [self registrateCellForClass:[ZPPOrderTotalCell class] reuseIdentifier:ZPPOrderTotalCellIdentifier];
  [self registrateCellForClass:[ZPPOrderAddressCell class] reuseIdentifier:ZPPOrderAddressCellIdentifier];
  [self registrateCellForClass:[ZPPCreditCardInfoCell class] reuseIdentifier:ZPPCreditCardInfoCellIdentifier];
}

- (ZPPOrderTimeChooserVC *)resultScreen {
  return [self.storyboard instantiateViewControllerWithIdentifier:ZPPOrderTimeChooserVCIdentifier];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

@end
