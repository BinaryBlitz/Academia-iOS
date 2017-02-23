//
//  ZPPOrderHistoryOrderTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderHistoryOrderTVC.h"

@import HCSStarRatingView;
#import "DTCustomColoredAccessory.h"

#import "ZPPStarsCell.h"
#import "ZPPCommentCell.h"
#import "ZPPContactCourierCell.h"
#import "ZPPOrderTotalCell.h"
#import "ZPPOrderItemCell.h"
#import "ZPPNoCreditCardCell.h"
#import "ZPPOrderTotalCell.h"
#import "ZPPOrderAddressCell.h"

#import "UITableViewController+ZPPTVCCategory.h"
#import "UIButton+ZPPButtonCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPServerManager+ZPPOrderServerManager.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"

#import "ZPPOrder.h"
#import "ZPPAddress.h"
#import "ZPPConsts.h"

static NSString *ZPPStarsCellIdentifier = @"ZPPStarsCellIdentifier";
static NSString *ZPPCommentCellIdentifier = @"ZPPCommentCellIdentifier";
static NSString *ZPPContactCourierCellIdentifier = @"ZPPContactCourierCellIdentifier";

static NSString *ZPPCommentPlaceHoldeText = @"Все ли вам понравилось?";

static NSString *ZPPOrderItemCellReuseIdentifier = @"ZPPOrderItemCellReuseIdentifier";
static NSString *ZPPNoCreditCardCellIdentifier = @"ZPPNoCreditCardCellIdentifier";
static NSString *ZPPOrderTotalCellIdentifier = @"ZPPOrderTotalCellIdentifier";
static NSString *ZPPOrderAddressCellIdentifier = @"ZPPOrderAddressCellIdentifier";

@interface ZPPOrderHistoryOrderTVC () <UITextViewDelegate>

@property (assign, nonatomic) BOOL shouldShowComment;
@property (strong, nonatomic) NSString *comment;
@property (strong, nonatomic) ZPPOrder *order;

@end

@implementation ZPPOrderHistoryOrderTVC

- (void)viewDidLoad {
  [super viewDidLoad];
  [self registerTableViewCells];
  [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
  [self setNeedsStatusBarAppearanceUpdate];
  self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

  self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
  self.tableView.tintColor = [UIColor blackColor];
  self.tableView.sectionFooterHeight = 0.01;
}

- (void)viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];

  [self setCustomNavigationBackButtonWithTransition];
  [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
  [self.navigationController presentTransparentNavigationBar];

  [self addCustomCloseButton];

  [self.tableView reloadData];
}

- (void)registerTableViewCells {
  [self registrateCellForClass:[ZPPStarsCell class] reuseIdentifier:ZPPStarsCellIdentifier];
  [self registrateCellForClass:[ZPPCommentCell class] reuseIdentifier:ZPPCommentCellIdentifier];
  [self registrateCellForClass:[ZPPContactCourierCell class] reuseIdentifier:ZPPContactCourierCellIdentifier];

  [self registrateCellForClass:[ZPPOrderItemCell class] reuseIdentifier:ZPPOrderItemCellReuseIdentifier];
  [self registrateCellForClass:[ZPPNoCreditCardCell class] reuseIdentifier:ZPPNoCreditCardCellIdentifier];
  [self registrateCellForClass:[ZPPOrderTotalCell class] reuseIdentifier:ZPPOrderTotalCellIdentifier];
  [self registrateCellForClass:[ZPPOrderAddressCell class] reuseIdentifier:ZPPOrderAddressCellIdentifier];
}

- (void)configureWithOrder:(ZPPOrder *)order {
  self.order = order;
  [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.order.orderStatus == ZPPOrderStatusDelivered ||
      self.order.orderStatus == ZPPOrderStatusOnTheWay) {
    return 3;
  } else {
    return 2;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.order.items.count;
  } else if (section == 1) {
    return 1;
  } else {
    if (self.order.orderStatus == ZPPOrderStatusDelivered) {
      return 2;
    } else {
      return 1;
    }
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    ZPPOrderItem *orderItem = self.order.items[indexPath.row];

    ZPPOrderItemCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPOrderItemCellReuseIdentifier];
    [cell configureWithOrderItem:orderItem];
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.accessoryView = nil;

    return cell;
  } else if (indexPath.section == 1) {
    ZPPOrderTotalCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPOrderTotalCellIdentifier];
    [cell configureWithOrder:self.order];
    cell.deliveryLabel.text = [self.order.address formatedDescr];
    cell.deliveryLabel.font = [UIFont systemFontOfSize:17];
    return cell;
  } else {
    if (indexPath.row == 0) {
      if (self.order.orderStatus == ZPPOrderStatusDelivered) {
        return [self starCell];
      } else {
        return [self contactCell];
      }
    } else {
      ZPPCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPCommentCellIdentifier];

      [cell.actionButton addTarget:self
                            action:@selector(sendComment:)
                  forControlEvents:UIControlEventTouchUpInside];

      cell.commentTV.delegate = self;
      if (!self.order.commentString) {
        self.comment = @"";
        cell.commentTV.text = ZPPCommentPlaceHoldeText;
        cell.commentTV.textColor = [UIColor lightGrayColor];
      } else {
        cell.commentTV.text = self.order.commentString;
        cell.actionButton.hidden = YES;
        cell.commentTV.editable = NO;
      }

      return cell;
    }
  }
  return [UITableViewCell new];
}

- (ZPPStarsCell *)starCell {
  ZPPStarsCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ZPPStarsCellIdentifier];

  [cell.starView addTarget:self
                    action:@selector(valueChanged:)
          forControlEvents:UIControlEventValueChanged];

  cell.starView.value = self.order.starValue;

  return cell;
}

- (ZPPContactCourierCell *)contactCell {
  return [self.tableView dequeueReusableCellWithIdentifier:ZPPContactCourierCellIdentifier];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    return 46.f;
  } else if (indexPath.section == 2) {
    return 120.f;
  } else {
    return 100.f;
  }
}

- (void)valueChanged:(id)sender {
  if ([sender isKindOfClass:[HCSStarRatingView class]]) {
    HCSStarRatingView *ratingView = (HCSStarRatingView *) sender;

    [self sendStars:ratingView.value sender:ratingView];
  }
}

- (void)showCommentCell:(UIButton *)sender {
  sender.hidden = YES;
  self.shouldShowComment = YES;
  [self.tableView beginUpdates];

  NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:2];

  [self.tableView insertRowsAtIndexPaths:@[ip] withRowAnimation:UITableViewRowAnimationTop];

  [self.tableView endUpdates];

  ZPPCommentCell *cell = [self.tableView cellForRowAtIndexPath:ip];

  if (cell) {
    [cell.commentTV becomeFirstResponder];
  }
}

- (void)sendStars:(float)starValue sender:(HCSStarRatingView *)starView {
  [[ZPPServerManager sharedManager] patchStarsWithValue:@(starValue)
                                         forOrderWithID:self.order.identifier
                                              onSuccess:^{
                                                self.order.starValue = starValue;
                                              }
                                              onFailure:^(NSError *error, NSInteger statusCode) {
                                                [self showWarningWithText:ZPPNoInternetConnectionMessage];
                                                [self.tableView reloadData];
                                              }];
}

- (void)sendComment:(UIButton *)sender {
  [sender startIndicatingWithType:UIActivityIndicatorViewStyleGray];

  UITableViewCell *c = [self parentCellForView:sender];

  if (c && [c isKindOfClass:[ZPPCommentCell class]]) {
    ZPPCommentCell *cell = (ZPPCommentCell *) c;

    NSString *comment = cell.commentTV.text;
    [sender startIndicating];
    [[ZPPServerManager sharedManager] sendComment:comment
                                   forOrderWithID:self.order.identifier
                                        onSuccess:^{
                                          [sender stopIndication];
                                          [self showSuccessWithText:@"Комментарий отправлен!"];
                                          sender.hidden = YES;
                                          [cell.commentTV resignFirstResponder];
                                          cell.commentTV.editable = NO;

                                          self.order.commentString = comment;
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                          [sender stopIndication];
                                        }];
  }
}

#pragma mark - textview delegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
  if ([textView.text isEqualToString:ZPPCommentPlaceHoldeText]) {
    textView.text = @"";
    textView.textColor = [UIColor blackColor];
  }
  [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
  if ([textView.text isEqualToString:@""]) {
    textView.text = ZPPCommentPlaceHoldeText;
    textView.textColor = [UIColor lightGrayColor];
  }
  [textView resignFirstResponder];
}

@end
