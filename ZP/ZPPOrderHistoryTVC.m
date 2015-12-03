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

@property (strong, nonatomic) NSArray *doneOrders;
@property (strong, nonatomic) NSArray *onTheWayOrders;

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

    [self setCustomNavigationBackButtonWithTransition];
    
    [self loadOrders];
}

- (void)configureWithOrder:(ZPPOrder *)order {

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows

    if(section == 0) {
        return  self.onTheWayOrders.count;
    } else {
        return self.doneOrders.count;
    }
    
    return self.orders.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPOrderHistoryCell *cell =
        [tableView dequeueReusableCellWithIdentifier:ZPPOrderHistoryCellIdentifier
                                        forIndexPath:indexPath];



    ZPPOrder *order;
    
    if(indexPath.section == 0) {
        order = self.onTheWayOrders[indexPath.row];
    } else {
        order = self.doneOrders[indexPath.row];
    }
    
    [cell configureWithOrder:order];

    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if(section==0) {
        return @"Заказы в пути";
    } else {
        return @"Доставленные заказы";
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 85.f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPOrder *order;
    if (indexPath.section == 0) {
        order = self.onTheWayOrders[indexPath.row];
    } else {
        order = self.doneOrders[indexPath.row];
    }

    [self showOrderScreenWithOrder:order];
}

#pragma mark - actions

- (void)showOrderScreenWithOrder:(ZPPOrder *)order {
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
        
        [self parseOrders:orders];

        [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [self.refreshControl endRefreshing];

        [self showWarningWithText:ZPPNoInternetConnectionMessage];
    }];
}

#pragma mark - support

- (void)parseOrders:(NSArray *)orders {
//    if(self.onTheWayOrders) {
//        return;
//    }
    
    NSMutableArray *onTheWayOrders = [NSMutableArray array];
    NSMutableArray *payedOrders = [NSMutableArray array];
    
    for(ZPPOrder *order in orders) {
        if(order.orderStatus == ZPPOrderStatusOnTheWay) {
            [onTheWayOrders addObject:order];
        } else if (order.orderStatus == ZPPOrderStatusDelivered) {
            [payedOrders addObject:order];
        }
    }
    
    self.onTheWayOrders = [NSArray arrayWithArray:onTheWayOrders];
    self.doneOrders = [NSArray arrayWithArray:payedOrders];
    [self.tableView reloadData];
}

- (void)registrateCells {
    [self registrateCellForClass:[ZPPOrderHistoryCell class]
                 reuseIdentifier:ZPPOrderHistoryCellIdentifier];
}


@end
