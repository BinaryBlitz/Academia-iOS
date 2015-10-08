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

//categories
#import "UIFont+ZPPFontCategory.h"

//libs
#import <LoremIpsum.h>



static NSString *ZPPProductMainCellIdentifier = @"ZPPProductsMainCellIdentifier";
static NSString *ZPPProductIngridientsCellIdentifier = @"ZPPProductCellIdentifier";
static NSString *ZPPProductMenuCellIdentifier = @"ZPPProductMenuCellIdentifier";
static NSString *ZPPProductAboutCellIdentifier = @"ZPPProductAboutCellIdentifier";

@interface ZPPProductTVC ()

//@property (assign, nonatomic) CGFloat screenHeight;
@property (assign, nonatomic) NSInteger numberOfRows;


@end

@implementation ZPPProductTVC

- (void)viewDidLoad {
    [super viewDidLoad];

  //  self.screenHeight = [UIScreen mainScreen].bounds.size.height;

  //  [self registerCells];
    
  //  self.tableView.backgroundColor = [UIColor blackColor];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
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
        return [self ingridientsCell];
    }
}

- (ZPPProductMainCell *)productMainCell {
    ZPPProductMainCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPProductMainCellIdentifier];

    [LoremIpsum asyncPlaceholderImageWithSize:CGSizeMake(640, self.screenHeight)
                                   completion:^(UIImage *image) {
                                       cell.productImageView.image = image;
                                   }];

    cell.nameLabel.text = [LoremIpsum word];
    cell.ingridientsDescriptionLabel.text = [LoremIpsum wordsWithNumber:3];
    cell.priceLabel.text = [NSString stringWithFormat:@"365 ₽"];
    cell.addToBasketButton.layer.borderWidth = 2.0;
    cell.addToBasketButton.layer.borderColor = [UIColor whiteColor].CGColor;
    cell.contentView.backgroundColor = [UIColor blackColor];

    return cell;
}

- (ZPPProductsIngridientsCell *)ingridientsCell {
    ZPPProductsIngridientsCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPProductIngridientsCellIdentifier];

    for (UIImageView *iv in cell.ingredientsImageViews) {
        
  
        [LoremIpsum asyncPlaceholderImageWithSize:CGSizeMake(100, 100)
                                       completion:^(UIImage *image) {
                                           iv.image = image;
                                       }];
    }

    for (UILabel *l in cell.ingredientsLabels) {
        l.text = [LoremIpsum word];
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

    cell.aboutTextView.text = [LoremIpsum sentencesWithNumber:3];
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
        return 380.0;
    } else {
        return [UIScreen mainScreen].bounds.size.width/3.0 + 40;
    }
}

- (void)registreCells  {
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



-(NSInteger)numberOfRows {
    return 5;
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
