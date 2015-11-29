//
//  ZPPOrderHistoryOrderTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderHistoryOrderTVC.h"
#import "ZPPStarsCell.h"
#import "ZPPCommentCell.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "ZPPOrder.h"
#import <HCSStarRatingView.h>

static NSString *ZPPStarsCellIdentifier = @"ZPPStarsCellIdentifier";
static NSString *ZPPCommentCellIdentifier = @"ZPPCommentCellIdentifier";

@interface ZPPOrderHistoryOrderTVC ()

@property (assign, nonatomic) BOOL shouldShowComment;

@end

@implementation ZPPOrderHistoryOrderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];

    [self registrateCellForClass:[ZPPStarsCell class] reuseIdentifier:ZPPStarsCellIdentifier];
    [self registrateCellForClass:[ZPPCommentCell class] reuseIdentifier:ZPPCommentCellIdentifier];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (self.order.orderStatus == ZPPOrderStatusDelivered) {
        return 3;
    } else {
        return 2;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSInteger count = [super tableView:tableView numberOfRowsInSection:1];
        NSLog(@"%@", @(count));
        return count;  //[super tableView:tableView numberOfRowsInSection:2];
    } else if (section == 1) {
        return 1;
    } else {
        if (self.shouldShowComment) {
            return 2;
        } else {
            return 1;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSIndexPath *nip = [NSIndexPath indexPathForRow:indexPath.row inSection:1];

        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:nip];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.accessoryView = nil;
        return cell;
    } else if (indexPath.section == 1) {
        NSIndexPath *nip = [NSIndexPath indexPathForRow:indexPath.row inSection:2];
        return [super tableView:tableView cellForRowAtIndexPath:nip];

    } else {
        if (indexPath.row == 0) {
            ZPPStarsCell *cell =
                [tableView dequeueReusableCellWithIdentifier:ZPPStarsCellIdentifier];

            [cell.starView addTarget:self
                              action:@selector(valueChanged:)
                    forControlEvents:UIControlEventValueChanged];

            [cell.actionButton addTarget:self
                                  action:@selector(showCommentCell:)
                        forControlEvents:UIControlEventTouchUpInside];

            cell.starView.shouldBeginGestureRecognizerBlock = ^BOOL(UIGestureRecognizer *gr) {

                return cell.starView.value == 0.0;
            };

            return cell;
        } else {
            ZPPCommentCell *cell =
                [tableView dequeueReusableCellWithIdentifier:ZPPCommentCellIdentifier];

            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSIndexPath *nip = [NSIndexPath indexPathForRow:indexPath.row inSection:1];
        return [super tableView:tableView heightForRowAtIndexPath:nip];
    } else {
        NSIndexPath *nip = [NSIndexPath indexPathForRow:indexPath.row inSection:2];
        return [super tableView:tableView heightForRowAtIndexPath:nip];
    }
}

- (void)valueChanged:(id)sender {
    if ([sender isKindOfClass:[HCSStarRatingView class]]) {
        HCSStarRatingView *stars = (HCSStarRatingView *)sender;

        if (stars.value) {
            stars.enabled = NO;
        }
    }
}

- (void)showCommentCell:(UIButton *)sender {
    sender.hidden = YES;
    self.shouldShowComment = YES;
    [self.tableView beginUpdates];

    NSIndexPath *ip = [NSIndexPath indexPathForRow:1 inSection:2];

    [self.tableView insertRowsAtIndexPaths:@[ ip ] withRowAnimation:UITableViewRowAnimationTop];

    [self.tableView endUpdates];
}
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
