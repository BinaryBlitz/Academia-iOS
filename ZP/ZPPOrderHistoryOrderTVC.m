//
//  ZPPOrderHistoryOrderTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPOrderHistoryOrderTVC.h"

@interface ZPPOrderHistoryOrderTVC ()

@end

@implementation ZPPOrderHistoryOrderTVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView reloadData];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        NSInteger count = [super tableView:tableView numberOfRowsInSection:2];
        NSLog(@"%@", @(count));
        return count;  //[super tableView:tableView numberOfRowsInSection:2];
    } else {
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        NSIndexPath *nip = [NSIndexPath indexPathForRow:indexPath.row inSection:2];
        
        UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:nip];
        cell.accessoryType = UITableViewCellAccessoryNone;
        return cell;
    } else {
        return [super tableView:tableView
            cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return;
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
