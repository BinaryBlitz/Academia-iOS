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
#import "ZPPIngridient.h"

#import "UIView+UIViewCategory.h"

#import <AFNetworking/UIImageView+AFNetworking.h>

// categories
#import "UIFont+ZPPFontCategory.h"

#import "ZPPDish.h"

#import "ZPPOrder.h"
#import "ZPPOrderItem.h"

// libs
//#import <LoremIpsum.h>

static NSString *ZPPProductMainCellIdentifier = @"ZPPProductsMainCellIdentifier";
static NSString *ZPPProductIngridientsCellIdentifier = @"ZPPProductCellIdentifier";
static NSString *ZPPProductMenuCellIdentifier = @"ZPPProductMenuCellIdentifier";
static NSString *ZPPProductAboutCellIdentifier = @"ZPPProductAboutCellIdentifier";

@interface ZPPProductTVC ()

//@property (assign, nonatomic) CGFloat screenHeight;

@property (strong, nonatomic) ZPPDish *dish;

@property (assign, nonatomic) NSInteger numberOfRows;
@property (strong, nonatomic) ZPPOrder *order;

@end

@implementation ZPPProductTVC

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.numberOfRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return [self productMainCell];
    } else if (indexPath.row == 1) {
        return [self menuCell];
    } else if (indexPath.row == [self.tableView numberOfRowsInSection:0] - 1) {
        return [self aboutCell];
    } else {
        return [self ingridientsCellForIndexPath:indexPath];
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

    cell.nameLabel.text = self.dish.name;  //[LoremIpsum word];
    cell.ingridientsDescriptionLabel.text = self.dish.subtitle;//[LoremIpsum wordsWithNumber:3];
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

- (UITableViewCell *)menuCell {
    UITableViewCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPProductMenuCellIdentifier];
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
    if (indexPath.row == 0) {
        return self.screenHeight;
    } else if (indexPath.row == 1) {
        return 67.0;
    } else if (indexPath.row == self.numberOfRows - 1) {
        return 280.0;
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
}

- (NSInteger)numberOfRows {
    NSInteger incr = 0;
    if (self.dish.ingridients.count % 3 > 0) {
        incr = 1;
    }
    return 3 + incr + self.dish.ingridients.count / 3;
}

#pragma mark - action

- (void)addToBasketAction:(UIButton *)sender {
    [self.productDelegate addItemIntoOrder:self.dish];
    [self.tableView reloadData];
}

#pragma mark - lazy

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
