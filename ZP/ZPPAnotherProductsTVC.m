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
#import "ZPPStuff.h"

#import "UIViewController+ZPPViewControllerCategory.h"

#import <UIImageView+AFNetworking.h>

#import "ZPPConsts.h"
#import "ZPPOrder.h"

#import "ZPPOrderItem.h"
//#import <LoremIpsum.h>

static NSString *ZPPProductAnotherCellIdentifier = @"ZPPProductAnotherCellIdentifier";
static NSString *ZPPProductMainCellIdentifier = @"ZPPProductsMainCellIdentifier";

static NSString *ZPPControllerName = @"ДОПОЛНИ СВОЙ ЛАНЧ!";
static NSString *ZPPControllerDescrioption = @"НАПИТКИ / СМУЗИ / ДЕСЕРТЫ";

@interface ZPPAnotherProductsTVC ()

@property (strong, nonatomic) NSArray *anotherProducts;
@property (strong, nonatomic) ZPPOrder *order;

@end

@implementation ZPPAnotherProductsTVC

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.order = order;
}
- (void)configureWithStuffs:(NSArray *)stuffs {
    self.anotherProducts = stuffs;
    [self.tableView reloadData];
}

//- (void)configureWithStuffs:(NSArray *)stuffs order:(ZPPOrder *)order {
//    self.order = order;
//    [self configureWithStuffs:stuffs];
//}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    } else {
        return self.anotherProducts.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return [self mainCell];
    } else {
        return [self anotherProductCellForIndexPath:indexPath];
    }
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return self.screenHeight;
    } else {
        return 120.0;
    }
}

- (ZPPProductAnotherCell *)anotherProductCellForIndexPath:(NSIndexPath *)indexPath {
    ZPPProductAnotherCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPProductAnotherCellIdentifier];

    ZPPStuff *stuff = self.anotherProducts[indexPath.row];


    ZPPOrderItem *orderItem = [self.order orderItemForItem:stuff];
    
    if (orderItem) {
        [cell setBadgeCount:orderItem.count];
    }
    
    [cell configureWithStuff:stuff];
    

    [cell.addProductButton addTarget:self
                              action:@selector(addToCard:)
                    forControlEvents:UIControlEventTouchUpInside];
    
//    self.
//    
//    cell setBadgeCount:<#(NSInteger)#>

    return cell;
}

- (ZPPProductMainCell *)mainCell {
    ZPPProductMainCell *cell =
        [self.tableView dequeueReusableCellWithIdentifier:ZPPProductMainCellIdentifier];

    cell.nameLabel.text = ZPPControllerName;
    cell.ingridientsDescriptionLabel.text = ZPPControllerDescrioption;
    cell.priceLabel.text = @"";
    [cell.addToBasketButton addTarget:self
                               action:@selector(showAnotherCells)
                     forControlEvents:UIControlEventTouchUpInside];
    [cell.addToBasketButton setTitle:@"ВНИЗ" forState:UIControlStateNormal];

    cell.productImageView.image = [UIImage imageNamed:@"back4"];

    CGSize size = cell.addToBasketButton.bounds.size;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 3)];
    v.backgroundColor = [UIColor whiteColor];
    [cell.addToBasketButton addSubview:v];

    return cell;
}

- (void)registreCells {
    UINib *anotherCell = [UINib nibWithNibName:@"ZPPProductAnotherCell" bundle:nil];
    [[self tableView] registerNib:anotherCell
           forCellReuseIdentifier:ZPPProductAnotherCellIdentifier];

    UINib *main = [UINib nibWithNibName:@"ZPPProductMainCell" bundle:nil];
    [[self tableView] registerNib:main forCellReuseIdentifier:ZPPProductMainCellIdentifier];
}

#pragma mark - actions

- (void)showAnotherCells {//redo
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:1]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

- (void)addToCard:(UIButton *)sender {
    UITableViewCell *cell = [self parentCellForView:sender];
    if (cell) {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];

        ZPPStuff *stuff = self.anotherProducts[ip.row];

        if (self.productDelegate) {
            [self.productDelegate addItemIntoOrder:stuff];
        }
    }
    
    [self.tableView reloadData];
}
@end
