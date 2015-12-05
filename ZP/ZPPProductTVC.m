//
//  ZPPProductTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductTVC.h"
#import "ZPPProductsIngridientsCell.h"
#import "ZPPProductMainCell.h"
#import "ZPPProductAboutCell.h"
#import "ZPPBadgeCell.h"
#import "ZPPIngridientAnotherCell.h"
#import "ZPPBadgeForTwoCell.h"
#import "ZPPIngridient.h"

#import "UITableViewController+ZPPTVCCategory.h"

#import "UIView+UIViewCategory.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

// categories
#import "UIFont+ZPPFontCategory.h"

#import "ZPPDish.h"
#import "ZPPBadge.h"

#import "ZPPOrder.h"
#import "ZPPOrderItem.h"

// libs
//#import <LoremIpsum.h>

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
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self showBottomCells];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        return 2;
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return self.numberOfRows;
    } else {
        NSInteger incr = 0;
        if (self.dish.badges.count % 3 > 0) {
            incr = 1;
        }
        return self.dish.badges.count / 3 + incr;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return [self productMainCell];
        } else if (indexPath.row == 1) {
            return [self menuCell];
        } else if (indexPath.row == [self.tableView numberOfRowsInSection:0] - 1) {
            return [self aboutCell];
        } else {
            return [self commonIngridientCellForIndexPath:indexPath];
        }
    } else {
        return [self badgeCellForIndexPath:indexPath];
    }
}

- (ZPPProductMainCell *)productMainCell {
    ZPPProductMainCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPProductMainCellIdentifier];

    //    [LoremIpsum asyncPlaceholderImageWithSize:CGSizeMake(640, self.screenHeight)
    //                                   completion:^(UIImage *image) {
    //                                       cell.productImageView.image = image;
    //                                   }];
    NSURL *imgURL = [NSURL URLWithString:self.dish.urlAsString];
    [cell.productImageView setImageWithURL:imgURL];

    cell.nameLabel.text = self.dish.name;                        //[LoremIpsum word];
    cell.ingridientsDescriptionLabel.text = self.dish.subtitle;  //[LoremIpsum wordsWithNumber:3];
    cell.priceLabel.text =
        [NSString stringWithFormat:@"%@ ₽", self.dish.price];  //[self.dish.price stringValue];
                                                                 ////[NSString

    [cell.addToBasketButton makeBorderedWithColor:[UIColor whiteColor]];
    cell.contentView.backgroundColor = [UIColor blackColor];

    [cell.addToBasketButton addTarget:self
                               action:@selector(addToBasketAction:)
                     forControlEvents:UIControlEventTouchUpInside];

    ZPPOrderItem *orderItem = [self.order orderItemForItem:self.dish];

    if (orderItem) {
        [cell.addToBasketButton setTitle:@"ЗАКАЗАТЬ ЕЩЕ" forState:UIControlStateNormal];

        //[cell setBadgeCount:orderItem.count];
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
        if (index >= self.dish.ingridients.count) {
            break;
        }

        UIImageView *iv = cell.ingredientsImageViews[i];
        UILabel *label = cell.ingredientsLabels[i];
        ZPPIngridient *ingr = self.dish.ingridients[index];
        NSURL *url = [NSURL URLWithString:ingr.urlAsString];
        [iv setImageWithURL:url];
        label.text = ingr.name;
    }
    return cell;
}

- (ZPPBadgeCell *)badgeCellForIndexPath:(NSIndexPath *)ip {
    
     NSInteger beg = ip.row;
    NSInteger index = beg * 3;
    
    ZPPBadgeForTwoCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ZPPBadgeForTwoCellID];
    
    if (self.dish.badges.count >= 2) {
        for(int i = 0; i < 2;i++) {
             UIImageView *iv = cell.badgesImageViews[i];
             UILabel *label = cell.badgesLabels[i];
             ZPPBadge *badge = self.dish.badges[i];
             [iv setImageWithURL:badge.imgURL];
             label.text = badge.name;
        }
    }
    return cell;
    
    
//    ZPPBadgeCell *cell = [self.tableView dequeueReusableCellWithIdentifier:ZPPBadgeCellIdentifier];
    
    

//    NSInteger beg = ip.row;
//
//    for (int i = 0; i < 3; i++) {
//        NSInteger index = beg * 3 + i;
//        if (index >= self.dish.badges.count) {
//            break;
//        }
//
//        UIImageView *iv = cell.badgesImageViews[i];
//        UILabel *label = cell.badgesLabels[i];
//        ZPPBadge *badge = self.dish.badges[index];
//        // NSURL *url = [NSURL URLWithString:badge.urlAsString];
//        [iv setImageWithURL:badge.imgURL];
//        label.text = badge.name;
//    }
//    return cell;
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

    cell.aboutTextView.text = self.dish.dishDescription;  //[LoremIpsum sentencesWithNumber:3];
    cell.aboutTextView.textAlignment = NSTextAlignmentCenter;
    cell.aboutTextView.font = [UIFont boldFontOfSize:15];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            return self.screenHeight;
        } else if (indexPath.row == 1) {
            return 67.0;
        } else if (indexPath.row == self.numberOfRows - 1) {
            return 280.0;
        } else {
            if (!self.isLunch) {
                return [UIScreen mainScreen].bounds.size.width / 3.0 + 20;
            } else {
                return 50.f;
            }
        }
    } else {
        return [UIScreen mainScreen].bounds.size.width / 3.0 + 20;
    }
}

- (void)registreCells {
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
    //    [self registrateCellForClass:[UITableViewCell class]
    //                 reuseIdentifier:ZPPProductIngredietntsJustCellID];
    UINib *ingtCellJust = [UINib nibWithNibName:@"ZPPProductIngredietntsJustCell" bundle:nil];
    [[self tableView] registerNib:ingtCellJust
           forCellReuseIdentifier:ZPPProductIngredietntsJustCellID];
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

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)),
                       dispatch_get_main_queue(), ^{
                           [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                           NSIndexPath *ip = [NSIndexPath indexPathForRow:0 inSection:0];
                           [self.tableView scrollToRowAtIndexPath:ip
                                                 atScrollPosition:UITableViewScrollPositionTop
                                                         animated:YES];
                       });
    }
}

//-(VBFPopFlatButton *)menuButton {
//    if(!_menuButton) {
//        _menuButton = [VBFPopFlatButton bu]
//    }
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
