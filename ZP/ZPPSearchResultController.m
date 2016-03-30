//
//  ZPPSearchResultController.m
//  ZP
//
//  Created by Andrey Mikhaylov on 11/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPSearchResultController.h"

#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"

#import "ZPPAddress.h"
#import "ZPPMapSearcher.h"

#import "ZPPConsts.h"

#import "LoremIpsum.h"

static NSString *ZPPSearchResultCellIdentifier = @"ZPPSearchResultCellIdentifier";

@interface ZPPSearchResultController () <UISearchBarDelegate>

@property (strong, nonatomic) NSArray *results;

@end

@implementation ZPPSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self setCustomNavigationBackButtonWithTransition];

    UIEdgeInsets insets = self.tableView.contentInset;
    self.tableView.contentInset =
        UIEdgeInsetsMake(insets.top + 20, insets.left, insets.bottom, insets.right);

    self.searchBar.delegate = self;

    self.searchBar.tintColor = [UIColor blackColor];
    
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    self.tableView.estimatedRowHeight = 60;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.searchBar becomeFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:ZPPSearchResultCellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:ZPPSearchResultCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

    ZPPAddress *adr = self.results[indexPath.row];

    cell.textLabel.text = adr.addres;
    cell.textLabel.numberOfLines = 0;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPAddress *address = self.results[indexPath.row];

    if (![address isKindOfClass:[ZPPAddress class]]) {
        return;
    }

    self.searchBar.text = address.addres;
    
    if (self.addressSearchDelegate) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[ZPPMapSearcher shared] searcDaDataWithAddress:address.addres
            count:@(1)
            onSuccess:^(NSArray *addresses) {

                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                ZPPAddress *adr = [addresses lastObject];

                [self.addressSearchDelegate configureWithAddress:adr sender:self];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
            onFailure:^(NSError *error, NSInteger statusCode){
                
                [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;

            }];
    }
}

#pragma mark - search delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.view endEditing:YES];
}

#pragma mark - server

- (void)searchWithText:(NSString *)text {
    if (!text || text.length < 3) {
        return;
    }

    [[ZPPMapSearcher shared] searcDaDataWithAddress:text
        count:@(10)
        onSuccess:^(NSArray *addresses) {

            self.results = addresses;
            [self.tableView reloadData];

        }
        onFailure:^(NSError *error, NSInteger statusCode){

        }];
}

@end
