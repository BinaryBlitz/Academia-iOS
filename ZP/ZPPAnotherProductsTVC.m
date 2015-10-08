//
//  ZPPAnotherProductsTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAnotherProductsTVC.h"
#import "ZPPProductAnotherCell.h"
#import "ZPPProductMainCell.h"

#import <LoremIpsum.h>

static NSString *ZPPProductAnotherCellIdentifier = @"ZPPProductAnotherCellIdentifier";
static NSString *ZPPProductMainCellIdentifier = @"ZPPProductsMainCellIdentifier";

static NSString *ZPPControllerName = @"ДОПОЛНИ СВОЙ ЛАНЧ!";
static NSString *ZPPControllerDescrioption = @"НАПИТКИ / СМУЗИ / ДЕСЕРТЫ";

@interface ZPPAnotherProductsTVC ()

@property (strong, nonatomic) NSArray *anotherProducts;

@end

@implementation ZPPAnotherProductsTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.anotherProducts = @[ [LoremIpsum word], [LoremIpsum word],
                              [LoremIpsum word], [LoremIpsum word],
                              [LoremIpsum word], [LoremIpsum word] ];
    
   //r [self registateCells];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.anotherProducts.count + 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row == 0) {
        return [self mainCell];
    } else {
        return [self anotherProductCellForIndexPath:indexPath];
    }
}


#pragma mark - UITableViewDelegate

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.row == 0){
        return self.screenHeight;
    } else {
        return 120.0;
    }
}


-(ZPPProductAnotherCell *)anotherProductCellForIndexPath:(NSIndexPath *)indexPath {
    ZPPProductAnotherCell *cell = [self.tableView
                                   dequeueReusableCellWithIdentifier:ZPPProductAnotherCellIdentifier];
    
    cell.nameLabel.text = self.anotherProducts[indexPath.row-1];
    cell.productDescriptionLabel.text = [LoremIpsum wordsWithNumber:3];
    cell.priceLabel.text = [NSString stringWithFormat:@"%u", arc4random() % 100 + 100];
    
    [LoremIpsum asyncPlaceholderImageWithSize:CGSizeMake(640, self.screenHeight)
                                   completion:^(UIImage *image) {
                                       cell.pictureImageView.image = image;
                                   }];
    
    return cell;
    
}

-(ZPPProductMainCell *)mainCell {
    ZPPProductMainCell *cell = [self.tableView
                                dequeueReusableCellWithIdentifier:ZPPProductMainCellIdentifier];
    
    cell.nameLabel.text = ZPPControllerName;
    cell.ingridientsDescriptionLabel.text = ZPPControllerDescrioption;
    cell.priceLabel.text = @"";
    [cell.addToBasketButton addTarget:self action:@selector(showAnotherCells) forControlEvents:UIControlEventTouchUpInside];
    [cell.addToBasketButton setTitle:@"ВНИЗ" forState:UIControlStateNormal];
    
    [LoremIpsum asyncPlaceholderImageWithSize:CGSizeMake(640, self.screenHeight)
                                   completion:^(UIImage *image) {
                                       cell.productImageView.image = image;
                                   }];
    
    return cell;
}



- (void)registreCells  {
    
    UINib *anotherCell = [UINib nibWithNibName:@"ZPPProductAnotherCell" bundle:nil];
    [[self tableView] registerNib:anotherCell
           forCellReuseIdentifier:ZPPProductAnotherCellIdentifier];
    
    UINib *main = [UINib nibWithNibName:@"ZPPProductMainCell" bundle:nil];
    [[self tableView] registerNib:main
           forCellReuseIdentifier:ZPPProductMainCellIdentifier];
    
}


#pragma mark - actions

-(void)showAnotherCells {
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1
                                                              inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}
@end
