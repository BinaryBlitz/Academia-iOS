//
//  ZPPCardInputTVC.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardInputTVC.h"
#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIView+UIViewCategory.h"
#import "UIViewController+ZPPValidationCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"

#import "ZPPCardNumberInputCell.h"
#import "ZPPCardDateCodeCell.h"

#import "ZPPConsts.h"

static NSString *ZPPCardNumberInputCellIdentifier = @"ZPPCardNumberInputCellIdentifier";

static NSString *ZPPCardDateCodeCellIdentifier = @"ZPPCardDateCodeCellIdentifier";

@interface ZPPCardInputTVC ()

@end

@implementation ZPPCardInputTVC

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self setCustomNavigationBackButtonWithTransition];
    [self addCustomCloseButton];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];

    [self registrateCellForClass:[ZPPCardNumberInputCell class]
                 reuseIdentifier:ZPPCardNumberInputCellIdentifier];
    [self registrateCellForClass:[ZPPCardDateCodeCell class]
                 reuseIdentifier:ZPPCardDateCodeCellIdentifier];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController presentTransparentNavigationBar];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        ZPPCardNumberInputCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPCardNumberInputCellIdentifier];

        return cell;
    } else if (indexPath.section == 1) {
        ZPPCardDateCodeCell *cell =
            [tableView dequeueReusableCellWithIdentifier:ZPPCardDateCodeCellIdentifier];

        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 90.f;
    } else {
        return 50.f;
    }
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
