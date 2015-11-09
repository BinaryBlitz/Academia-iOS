//
//  ZPPCardViewController.m
//  ZP
//
//  Created by Andrey Mikhaylov on 02/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardViewController.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "ZPPAddNewCell.h"

#import "ZPPConsts.h"

#import "UITableViewController+ZPPTVCCategory.h"

static NSString *ZPPAddNewCellIdentifier = @"ZPPAddNewCellIdentifier";

static NSString *ZPPCardInputTVCIdentifier = @"ZPPCardInputTVCIdentifier";

@interface ZPPCardViewController ()

@end

@implementation ZPPCardViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registrateCells];
    [self setCustomNavigationBackButtonWithTransition];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;

    // Uncomment the following line to display an Edit button in the navigation bar for this view
    // controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //    UITableViewCell *cell = [tableView
    //    dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];

    if (indexPath.section == 0) {
        ZPPAddNewCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:ZPPAddNewCellIdentifier];

        // Configure the cell...

        return cell;
    } else {
    }

    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 0) {
        [self showCardInput];
    }
}

#pragma mark - actions

- (void)showCardInput {
    UIViewController *vc =
        [self.storyboard instantiateViewControllerWithIdentifier:ZPPCardInputTVCIdentifier];
    
    [self.navigationController pushViewController:vc animated:YES];
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
    [self registrateCellForClass:[ZPPAddNewCell class] reuseIdentifier:ZPPAddNewCellIdentifier];
}

@end
