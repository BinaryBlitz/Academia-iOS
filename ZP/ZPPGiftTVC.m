//
//  ZPPGiftTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPGiftTVC.h"
#import "ZPPOrder.h"

#import "ZPPGiftCell.h"
#import "ZPPActivateCardCell.h"

#import "ZPPGift.h"
#import "ZPPOrderItem.h"

#import "UIViewController+ZPPViewControllerCategory.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "UIButton+ZPPButtonCategory.h"

#import "ZPPServerManager+ZPPGiftServerManager.h"

#import "ZPPConsts.h"

static NSString *ZPPGiftCellIdentifier = @"ZPPGiftCellIdentifier";
static NSString *ZPPActivateCardCellIdentifier = @"ZPPActivateCardCellIdentifier";

@interface ZPPGiftTVC ()

@property (strong, nonatomic) ZPPOrder *order;

@property (strong, nonatomic) NSArray *gifts;

@end

@implementation ZPPGiftTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(loadGifts)
                  forControlEvents:UIControlEventValueChanged];

    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    [self registrateCells];

    // [self loadGifts];

    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];

    self.tableView.backgroundView.layer.zPosition -= 1;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self loadGifts];

    [self.navigationController presentTransparentNavigationBar];
    [self addCustomCloseButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)configureWithOrder:(ZPPOrder *)order {
    self.order = order;
    [self.tableView reloadData];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //#warning Incomplete implementation, return the number of rows
    if (section == 0) {
        return self.gifts.count;
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZPPGiftCell *cell =
            [self.tableView dequeueReusableCellWithIdentifier:ZPPGiftCellIdentifier];

        ZPPGift *g = self.gifts[indexPath.row];

        [cell configureWithGift:g];

        ZPPOrderItem *orderItem = [self.order orderItemForItem:g];

        if (orderItem) {
            [cell setBadgeCount:orderItem.count];
        }

        [cell.addButton addTarget:self
                           action:@selector(addToCard:)
                 forControlEvents:UIControlEventTouchUpInside];

        return cell;
    } else {
        ZPPActivateCardCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPActivateCardCellIdentifier];

        [cell.doneButton addTarget:self
                            action:@selector(activateCard:)
                  forControlEvents:UIControlEventTouchUpInside];

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 110.f;
    } else {
        return 175.f;
    }
}

#pragma mark - actions

- (void)addToCard:(UIView *)sender {
    UITableViewCell *cell = [self parentCellForView:sender];

    if (cell) {
        NSIndexPath *ip = [self.tableView indexPathForCell:cell];

        ZPPGift *g = self.gifts[ip.row];

        [self.order addItem:g];

        [self.tableView reloadData];
        //  [self.tableView reloadRowsAtIndexPaths:[]
        //  withRowAnimation:<#(UITableViewRowAnimation)#>]
    }
}

- (void)activateCard:(UIButton *)sender {
    [sender startIndicating];

    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)),
                   dispatch_get_main_queue(), ^{
                       [sender stopIndication];
                       [self showSuccessWithText:@"Карта добавлена"];

                   });
}

- (void)loadGifts {
    [self.refreshControl beginRefreshing];

    if (self.tableView.contentOffset.y == 0) {
        [self.tableView setContentOffset:CGPointMake(0, self.tableView.contentOffset.y -
                                                            self.refreshControl.frame.size.height)
                                animated:YES];
    }

    [[ZPPServerManager sharedManager] GETGiftsOnSuccess:^(NSArray *gifts) {
        [self.refreshControl endRefreshing];
        self.gifts = gifts;
        [self.tableView reloadData];
    } onFailure:^(NSError *error, NSInteger statusCode) {
        [self.refreshControl endRefreshing];

        [self showWarningWithText:ZPPNoInternetConnectionMessage];

    }];
}

#pragma mark - support

- (void)registrateCells {
    [self registrateCellForClass:[ZPPGiftCell class] reuseIdentifier:ZPPGiftCellIdentifier];
    [self registrateCellForClass:[ZPPActivateCardCell class]
                 reuseIdentifier:ZPPActivateCardCellIdentifier];
}

#pragma mark - test

//- (void)registrateCellForClass:(Class) class reuseIdentifier:(NSString *)reuseIdentifier {
//    NSString *className = NSStringFromClass(class);
//    UINib *nib = [UINib nibWithNibName:className bundle:nil];
//    [[self tableView] registerNib:nib forCellReuseIdentifier:reuseIdentifier];
//}

@end
