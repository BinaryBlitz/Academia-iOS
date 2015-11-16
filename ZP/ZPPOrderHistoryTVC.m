//
//  ZPPOrderHistoryTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderHistoryTVC.h"

#import "ZPPOrder.h"

#import "ZPPOrderHistoryCell.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"

#import "ZPPDish.h"

#import "ZPPServerManager+ZPPOrderServerManager.h"

#import "ZPPOrderHistoryOrderTVC.h"
#import "ZPPOrderTotalCell.h"

#import "ZPPConsts.h"

static NSString *ZPPOrderHistoryCellIdentifier = @"ZPPOrderHistoryCellIdentifier";
static NSString *ZPPOrderTVCIdentifier = @"ZPPOrderTVCIdentifier";
static NSString *ZPPOrderHistoryOrderTVCIdentifier = @"ZPPOrderHistoryOrderTVCIdentifier";
static NSString *ZPPOrderTotalCellIdentifier = @"ZPPOrderTotalCellIdentifier";

@interface ZPPOrderHistoryTVC ()

@property (strong, nonatomic) NSArray *orders;

@end

@implementation ZPPOrderHistoryTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self registrateCells];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;


    self.tableView.tableFooterView = [[UIView alloc] init];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    [self addCustomCloseButton];

    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadOrders)
                  forControlEvents:UIControlEventValueChanged];

    self.tableView.backgroundView.layer.zPosition -= 1;

    //   [self.tableView bringSubviewToFront:self.refreshControl];

    [self setCustomNavigationBackButtonWithTransition];
    
    [self loadOrders];
}

- (void)configureWithOrder:(ZPPOrder *)order {
    //    ZPPOrder *secondOrder = [order copy];
    //    ZPPOrder *thirdOrder = [secondOrder copy];

    //    self.orders = [self testOrders];  //@[ order, order, order ];
    //    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows

    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPOrderHistoryCell *cell =
        [tableView dequeueReusableCellWithIdentifier:ZPPOrderHistoryCellIdentifier
                                        forIndexPath:indexPath];

    // Configure the cell...

    ZPPOrder *order = self.orders[indexPath.row];
    [cell configureWithOrder:order];

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPOrder *order = self.orders[indexPath.row];
    [self showOrderScreenWithOrder:order];
}

#pragma mark - actions

- (void)showOrderScreenWithOrder:(ZPPOrder *)order {
    //   UIStoryboard *sb = [UIStoryboard storyboardWithName:@"order" bundle:[NSBundle mainBundle]];

    // ZPPOrderTVC *orderTVC = [sb instantiateViewControllerWithIdentifier:ZPPOrderTVCIdentifier];

    ZPPOrderHistoryOrderTVC *orderTVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPOrderHistoryOrderTVCIdentifier];

    [orderTVC configureWithOrder:order];

    [self.navigationController pushViewController:orderTVC animated:YES];
}

- (void)loadOrders {
    [self.refreshControl beginRefreshing];

    if (self.tableView.contentOffset.y == 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y -
                                                            self.refreshControl.frame.size.height)
                                animated:YES];
    }

    [[ZPPServerManager sharedManager] GETOldOrdersOnSuccess:^(NSArray *orders) {
        [self.refreshControl endRefreshing];

        self.orders = orders;

        [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [self.refreshControl endRefreshing];

        [self showWarningWithText:ZPPNoInternetConnectionMessage];
    }];
}

#pragma mark - support

- (void)registrateCells {
    [self registrateCellForClass:[ZPPOrderHistoryCell class]
                 reuseIdentifier:ZPPOrderHistoryCellIdentifier];
    //
    //    [self registrateCellForClass:[ZPPOrderTotalCell class]
    //                 reuseIdentifier:ZPPOrderTotalCellIdentifier];
}

#pragma mark - tests

//- (NSArray *)testOrders {
//    ZPPOrder *order = [[ZPPOrder alloc] init];
//    ZPPOrder *secondOrder = [[ZPPOrder alloc] init];
//    ZPPOrder *thirdOrder = [[ZPPOrder alloc] init];
//
//    ZPPDish *d1 = [[ZPPDish alloc] initWithName:@"Super meal"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(499)
//                                         imgURL:nil
//                                    ingridients:nil];
//    ZPPDish *d2 = [[ZPPDish alloc] initWithName:@"Diet meal"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(399)
//                                         imgURL:nil
//                                    ingridients:nil];
//    ZPPDish *d3 = [[ZPPDish alloc] initWithName:@"Hamburger"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(200)
//                                         imgURL:nil
//                                    ingridients:nil];
//    ZPPDish *d4 = [[ZPPDish alloc] initWithName:@"Salad"
//                                         dishID:nil
//                                       subtitle:nil
//                                dishDescription:nil
//                                          price:@(200)
//                                         imgURL:nil
//                                    ingridients:nil];
//
//    [order addItem:d1];
//    [order addItem:d1];
//    [order addItem:d4];
//    [order addItem:d2];
//
//    [secondOrder addItem:d4];
//    [secondOrder addItem:d1];
//    [secondOrder addItem:d3];
//    [secondOrder addItem:d3];
//
//    [thirdOrder addItem:d3];
//    [thirdOrder addItem:d2];
//    [thirdOrder addItem:d2];
//
//    return @[ order, secondOrder, thirdOrder ];
//}

@end
