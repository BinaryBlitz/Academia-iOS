//
//  ZPPOrderTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 30/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderTVC.h"
#import "ZPPOrder.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "ZPPOrderItemCell.h"
#import "ZPPNoCreditCardCell.h"

#import "ZPPCardViewController.h"
#import "ZPPOrderItemVC.h"

#import "ZPPConsts.h"

static NSString *ZPPOrderItemCellReuseIdentifier = @"ZPPOrderItemCellReuseIdentifier";
static NSString *ZPPNoCreditCardCellIdentifier = @"ZPPNoCreditCardCellIdentifier";
static NSString *ZPPCardViewControllerIdentifier = @"ZPPCardViewControllerIdentifier";
static NSString *ZPPOrderItemVCIdentifier = @"ZPPOrderItemVCIdentifier";

@interface ZPPOrderTVC ()

@property (strong, nonatomic) ZPPOrder *order;

@end

@implementation ZPPOrderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registrateCells];
    self.title = @"ЗАКАЗ";
    //   [self setCustomNavigationBackButtonWithTransition];
    [self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setCustomNavigationBackButtonWithTransition];
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self.navigationController presentTransparentNavigationBar];
    
    [self addCustomCloseButton];
    
    [self.tableView reloadData];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self hideIsNeeded];
}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.order = order;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows

    if (section == 2) {
        return self.order.items.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZPPNoCreditCardCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];
        [cell.actionButton setTitle:@"Выберите карточку" forState:UIControlStateNormal];

        [cell.actionButton addTarget:self
                              action:@selector(showCardChooser)
                    forControlEvents:UIControlEventTouchUpInside];
        return cell;
    } else if (indexPath.section == 1) {
        ZPPNoCreditCardCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];
        [cell.actionButton setTitle:@"Выберите адрес" forState:UIControlStateNormal];

        return cell;

    } else if (indexPath.section == 3) {
        ZPPNoCreditCardCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:ZPPNoCreditCardCellIdentifier];
        [cell.actionButton setTitle:@"Заказать" forState:UIControlStateNormal];

        return cell;

    } else {

        ZPPOrderItem *orderItem = self.order.items[indexPath.row];

        ZPPOrderItemCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPOrderItemCellReuseIdentifier];
        [cell configureWithOrderItem:orderItem];
        
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section != 2) {
        return 60.f;
    } else {
        return 50.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 2) {
        ZPPOrderItem *orderItem = self.order.items[indexPath.row];
        
        [self showItemModifier:orderItem];
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    if(indexPath.section == 0)
//}
//

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

#pragma mark - actions

- (void)showCardChooser {
    ZPPCardViewController *cardVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPCardViewControllerIdentifier];

    [self.navigationController pushViewController:cardVC animated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)showItemModifier:(ZPPOrderItem *)orderItem {
    ZPPOrderItemVC *orderVC =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPOrderItemVCIdentifier];

    [orderVC configureWithOrder:self.order item:orderItem];

    [self.navigationController pushViewController:orderVC animated:YES];
}


- (void)hideIsNeeded {
    if(self.order.items.count <= 0) {
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }

}

#pragma mark - support

- (void)registrateCells {
    [self registrateCellForClass:[ZPPOrderItemCell class]
                 reuseIdentifier:ZPPOrderItemCellReuseIdentifier];

    [self registrateCellForClass:[ZPPNoCreditCardCell class]
                 reuseIdentifier:ZPPNoCreditCardCellIdentifier];
}

//- (void)registrateCellForClass:(Class) class reuseIdentifier:(NSString *)reuseIdentifier {
//    NSString *className = NSStringFromClass(class);
//    UINib *nib = [UINib nibWithNibName:className bundle:nil];
//    [[self tableView] registerNib:nib forCellReuseIdentifier:reuseIdentifier];
//}

//    - (void)configureBackgroundImage {
//    CGRect r = CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds),
//                          16 * CGRectGetWidth([UIScreen mainScreen].bounds) / 9);
//
//    UIImageView *iv = [[UIImageView alloc] initWithFrame:r];
//
//    iv.image = [UIImage imageNamed:@"back1"];
//
//    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.backgroundView = iv;
//}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
