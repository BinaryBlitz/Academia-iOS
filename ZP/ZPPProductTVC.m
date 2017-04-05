#import "ZPPBadgeCell.h"
#import "ZPPBadgeForTwoCell.h"
#import "ZPPIngridientAnotherCell.h"
#import "ZPPProductAboutCell.h"
#import "ZPPProductEnergyCell.h"
#import "ZPPProductMainCell.h"
#import "ZPPProductTVC.h"
#import "ZPPProductsIngridientsCell.h"

#import "ZPPUser.h"
#import "ZPPUserManager.h"

#import "ZPPIngridient.h"

#import "UITableViewController+ZPPTVCCategory.h"

#import "UIView+UIViewCategory.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

// categories
#import "UIFont+ZPPFontCategory.h"

#import "ZPPBadge.h"
#import "ZPPDish.h"
#import "ZPPEnergy.h"

#import "ZPPOrder.h"
#import "ZPPOrderItem.h"

@import SDWebImage;

static NSString *ZPPProductMainCellIdentifier = @"ZPPProductsMainCellIdentifier";
static NSString *ZPPProductIngridientsCellIdentifier = @"ZPPProductCellIdentifier";
static NSString *ZPPProductMenuCellIdentifier = @"ZPPProductMenuCellIdentifier";
static NSString *ZPPProductAboutCellIdentifier = @"ZPPProductAboutCellIdentifier";
static NSString *ZPPBadgeCellIdentifier = @"ZPPBadgeCellIdentifier";
static NSString *ZPPIngridientAnotherCellIdentifier = @"ZPPIngridientAnotherCellIdentifier";
static NSString *ZPPProductIngredietntsJustCellID = @"ZPPProductIngredietntsJustCellID";
static NSString *ZPPBadgeForTwoCellID = @"ZPPBadgeForTwoCellID";

static NSString *ZPPIsTutorialAnimationShowed = @"ZPPIsTutorialAnimationShowed";

@interface ZPPProductTVC ()

//@property (assign, nonatomic) CGFloat screenHeight;

@property (strong, nonatomic) ZPPDish *dish;

@property (assign, nonatomic) BOOL isLunch;

@property (assign, nonatomic) NSInteger numberOfRows;
@property (strong, nonatomic) ZPPOrder *order;

@end

@implementation ZPPProductTVC

- (void)viewDidLoad {
  [super viewDidLoad];
  self.tableView.estimatedRowHeight = 100.f;
  self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self showBottomCells];
}

- (void)configureWithOrder:(ZPPOrder *)order {
  self.order = order;
}

- (void)configureWithDish:(ZPPDish *)dish {
  self.dish = dish;
  [self.tableView reloadData];
}

- (void)configureWithLunch:(ZPPDish *)lunch {
  self.dish = lunch;
  self.isLunch = YES;
  [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  if (self.dish.badges.count) {
    return 3;
  } else {
    return 2;
  }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  if (section == 0) {
    return self.numberOfRows;
  } else if (section == 2) {
    NSInteger incr = 0;
    if (self.dish.badges.count % 3 > 0) {
      incr = 1;
    }
    return self.dish.badges.count / 3 + incr;
  } else {
    return 1;
  }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return [self productMainCellForIp:indexPath];
    } else if (indexPath.row == 1) {
      return [self menuCell];
    } else if (indexPath.row == [self.tableView numberOfRowsInSection:0] - 1) {
      return [self aboutCell];
    } else {
      return [self commonIngridientCellForIndexPath:indexPath];
    }
  } else if (indexPath.section == 1) {
    return [self energyCell];
  } else {
    return [self badgeCellForIndexPath:indexPath];
  }
}

- (ZPPProductMainCell *)productMainCellForIp:(NSIndexPath *)ip {
  ZPPProductMainCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:ZPPProductMainCellIdentifier];

  NSURL *imgURL = [NSURL URLWithString:self.dish.urlAsString];

  [self loadImageView:cell.productImageView indexPath:ip url:imgURL];

  [cell setTitle: self.dish.name];
  [cell setIngridientsDescription: self.dish.subtitle];
  [cell setPrice: [NSString stringWithFormat:@"%@ ₽", self.dish.price]];

  [cell.addToBasketButton makeBorderedWithColor:[UIColor whiteColor]];
  cell.contentView.backgroundColor = [UIColor blackColor];

  [cell.addToBasketButton addTarget:self
                             action:@selector(addToBasketAction:)
                   forControlEvents:UIControlEventTouchUpInside];

  ZPPOrderItem *orderItem = [self.order orderItemForItem:self.dish];
  NSString *buttonText = cell.addToBasketButton.titleLabel.text;

  if (![ZPPUserManager sharedInstance].user.apiToken) {
    cell.addToBasketButton.hidden = YES;
  } else {
    cell.addToBasketButton.hidden = NO;
    if (self.dish.isNoItems) {
      buttonText = @"Блюдо закончилось";
      cell.addToBasketButton.enabled = NO;
      [cell.addToBasketButton makeBorderedWithColor:[UIColor clearColor]];
      cell.addToBasketButton.backgroundColor = [UIColor colorWithWhite:2 / 2.5 alpha:1];
      cell.addToBasketButton.titleLabel.font = [UIFont boldFontOfSize:16];
    } else if (orderItem) {
      buttonText = @"ЗАКАЗАТЬ ЕЩЕ";
      cell.addToBasketButton.enabled = YES;
    } else {
      cell.addToBasketButton.enabled = YES;
    }
    [cell.addToBasketButton setTitle:buttonText.uppercaseString forState:UIControlStateNormal];
  }

  return cell;
}

- (UITableViewCell *)commonIngridientCellForIndexPath:(NSIndexPath *)ip {
  if (self.isLunch) {
    return [self ingridientAnotherCellForIndexPath:ip];
  } else {
    return [self ingridientsCellForIndexPath:ip];
  }
}

- (ZPPIngridientAnotherCell *)ingridientAnotherCellForIndexPath:(NSIndexPath *)ip {
  ZPPIngridientAnotherCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:ZPPIngridientAnotherCellIdentifier];

  ZPPIngridient *ingr = self.dish.ingridients[ip.row - 2];

  cell.nameLabel.text = ingr.name;
  if (ingr.weight) {
    cell.priceLabel.text = [NSString stringWithFormat:@"%@ г", ingr.weight];
  } else {
    cell.priceLabel.text = @"";
  }

  return cell;
}

- (ZPPProductsIngridientsCell *)ingridientsCellForIndexPath:(NSIndexPath *)ip {
  ZPPProductsIngridientsCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:ZPPProductIngridientsCellIdentifier];

  NSInteger beg = ip.row - 2;

  for (int i = 0; i < 3; i++) {
    NSInteger index = beg * 3 + i;
    UIImageView *iv = cell.ingredientsImageViews[i];
    UILabel *label = cell.ingredientsLabels[i];
    if (index >= self.dish.ingridients.count) {
      iv.image = nil;
      label.text = @"";
      continue;
    }

    ZPPIngridient *ingr = self.dish.ingridients[index];
    NSURL *url = [NSURL URLWithString:ingr.urlAsString];
    [iv setImageWithURL:url];
    label.text = ingr.name;
  }
  return cell;
}

- (ZPPBadgeCell *)badgeCellForIndexPath:(NSIndexPath *)ip {
  NSInteger beg = ip.row;
  NSInteger ind = beg * 3;

  if (self.dish.badges.count - ind == 2) {
    ZPPBadgeForTwoCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPBadgeForTwoCellID];

    if (self.dish.badges.count >= 2) {
      for (int i = 0; i < 2; i++) {
        UIImageView *iv = cell.badgesImageViews[i];
        UILabel *label = cell.badgesLabels[i];
        ZPPBadge *badge = self.dish.badges[i + ind];
        //[iv setImageWithURL:badge.imgURL];

        [iv sd_setImageWithURL:badge.imgURL];
        label.text = badge.name;
      }
    }
    return cell;
  } else {
    ZPPBadgeCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPBadgeCellIdentifier];

    for (int i = 0; i < 3; i++) {
      NSInteger index = beg * 3 + i;
      UIImageView *iv = cell.badgesImageViews[i];
      UILabel *label = cell.badgesLabels[i];
      if (index >= self.dish.badges.count) {
        iv.image = nil;
        label.text = @"";
        continue;
      }
      ZPPBadge *badge = self.dish.badges[index];
      [iv sd_setImageWithURL:badge.imgURL];
      label.text = badge.name;
    }
    return cell;
  }
}

- (UITableViewCell *)menuCell {
  UITableViewCell *cell;

  if (self.isLunch) {
    cell = [self.tableView dequeueReusableCellWithIdentifier:ZPPProductMenuCellIdentifier];
  } else {
    cell = [self.tableView dequeueReusableCellWithIdentifier:ZPPProductIngredietntsJustCellID];
  }
  return cell;
}

- (ZPPProductAboutCell *)aboutCell {
  ZPPProductAboutCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:ZPPProductAboutCellIdentifier];

  cell.aboutLabel.text = self.dish.dishDescription;
  cell.aboutLabel.font = [UIFont boldFontOfSize:15];
  return cell;
}

- (ZPPProductEnergyCell *)energyCell {
  ZPPProductEnergyCell *cell =
      [self.tableView dequeueReusableCellWithIdentifier:ZPPProductEnergyCellIdentifier];

  if (self.dish.energy) {
    [cell configureWithDish:self.dish];
  } else {
    cell.contentView.hidden = YES;
  }

  return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
  if (indexPath.section == 0) {
    if (indexPath.row == 0) {
      return self.screenHeight;
    } else if (indexPath.row == 1) {
      return 67.0;
    } else if (indexPath.row == self.numberOfRows - 1) {
      if (self.dish.dishDescription.length > 0) {
        return UITableViewAutomaticDimension;
      } else {
        return 0;
      }
    } else {
      if (!self.isLunch) {
        return [UIScreen mainScreen].bounds.size.width / 3.0 + 10;
      } else {
        return UITableViewAutomaticDimension;
      }
    }
  } else if (indexPath.section == 1) {
    if (self.dish.energy) {
      return 142.0;
    } else {
      return 0;
    }
  } else {
    return [UIScreen mainScreen].bounds.size.width / 3.0 + 20;
  }
}

- (void)registerCells {
  UINib *ingridientsCell = [UINib nibWithNibName:@"ZPPProductsIngridientsCell" bundle:nil];
  [[self tableView] registerNib:ingridientsCell
         forCellReuseIdentifier:ZPPProductIngridientsCellIdentifier];
  UINib *mainCell = [UINib nibWithNibName:@"ZPPProductMainCell" bundle:nil];
  [[self tableView] registerNib:mainCell forCellReuseIdentifier:ZPPProductMainCellIdentifier];
  UINib *menuCell = [UINib nibWithNibName:@"ZPPProductMenuCell" bundle:nil];
  [[self tableView] registerNib:menuCell forCellReuseIdentifier:ZPPProductMenuCellIdentifier];
  UINib *aboutCell = [UINib nibWithNibName:@"ZPPProductAboutCell" bundle:nil];
  [[self tableView] registerNib:aboutCell forCellReuseIdentifier:ZPPProductAboutCellIdentifier];

  [self registrateCellForClass:[ZPPBadgeCell class] reuseIdentifier:ZPPBadgeCellIdentifier];
  [self registrateCellForClass:[ZPPIngridientAnotherCell class]
               reuseIdentifier:ZPPIngridientAnotherCellIdentifier];

  [self registrateCellForClass:[ZPPBadgeForTwoCell class] reuseIdentifier:ZPPBadgeForTwoCellID];
  UINib *ingtCellJust = [UINib nibWithNibName:@"ZPPProductIngredietntsJustCell" bundle:nil];
  [[self tableView] registerNib:ingtCellJust
         forCellReuseIdentifier:ZPPProductIngredietntsJustCellID];

  [self registrateCellForClass:[ZPPProductEnergyCell class]
               reuseIdentifier:ZPPProductEnergyCellIdentifier];
}

- (NSInteger)numberOfRows {
  if (!self.isLunch) {
    NSInteger incr = 0;
    if (self.dish.ingridients.count % 3 > 0) {
      incr++;
    }
    return 3 + incr + self.dish.ingridients.count / 3;
  } else {
    return 3 + self.dish.ingridients.count;
  }
}

#pragma mark - action

- (void)addToBasketAction:(UIButton *)sender {
  [self.productDelegate addItemIntoOrder:self.dish];
  [self.tableView reloadData];
}

#pragma mark - animation

- (void)showBottomCells {
  BOOL isShowed = [[NSUserDefaults standardUserDefaults] boolForKey:ZPPIsTutorialAnimationShowed];

  if (!isShowed) {
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:ZPPIsTutorialAnimationShowed];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];

    NSIndexPath *ip = [NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView scrollToRowAtIndexPath:ip
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t) (0.5 * NSEC_PER_SEC)),
        dispatch_get_main_queue(), ^{
          [[UIApplication sharedApplication] endIgnoringInteractionEvents];
          NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
          [self.tableView               scrollToRowAtIndexPath:ip
                                atScrollPosition:UITableViewScrollPositionTop
                                        animated:YES];
        });
  }
}

#pragma mark - img load

- (void)loadImageView:(UIImageView *)imgView indexPath:(NSIndexPath *)ip url:(NSURL *)url {
  SDWebImageManager *manager = [SDWebImageManager sharedManager];
  [manager downloadImageWithURL:url
                        options:0
                       progress:nil
                      completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType,
                          BOOL finished, NSURL *imageURL) {
                        if (image) {
                          imgView.image = image;
                        }
                      }];
}

@end
