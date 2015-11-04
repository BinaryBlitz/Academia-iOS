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

//#import "ZPPOrderTVC.h"
#import "ZPPOrderHistoryOrderTVC.h"

#import "ZPPConsts.h"

static NSString *ZPPOrderHistoryCellIdentifier = @"ZPPOrderHistoryCellIdentifier";
static NSString *ZPPOrderTVCIdentifier = @"ZPPOrderTVCIdentifier";
static NSString *ZPPOrderHistoryOrderTVCIdentifier = @"ZPPOrderHistoryOrderTVCIdentifier";

@interface ZPPOrderHistoryTVC ()

@property (strong, nonatomic) NSArray *orders;

@end

@implementation ZPPOrderHistoryTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view
    // controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.tableFooterView = [[UIView alloc] init];

    [self registrateCells];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController presentTransparentNavigationBar];
    [self addCustomCloseButton];
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    //[self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self setCustomNavigationBackButtonWithTransition];
}

- (void)configureWithOrder:(ZPPOrder *)order {
//    ZPPOrder *secondOrder = [order copy];
//    ZPPOrder *thirdOrder = [secondOrder copy];

    self.orders = @[ order, order, order ];
    [self.tableView reloadData];
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
    
    ZPPOrderHistoryOrderTVC *orderTVC = [self.storyboard instantiateViewControllerWithIdentifier:ZPPOrderHistoryOrderTVCIdentifier];
    
    [orderTVC configureWithOrder:order];
    
    [self.navigationController pushViewController:orderTVC animated:YES];
    
    
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath
*)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath]
withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new
row to the table view
    }
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath
toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before
navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - support

- (void)registrateCells {
    [self registrateCellForClass:[ZPPOrderHistoryCell class]
                 reuseIdentifier:ZPPOrderHistoryCellIdentifier];
}

@end
