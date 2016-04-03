//
//  ZPPSearchResultController.m
//  ZP
//
//  Created by Andrey Mikhaylov on 11/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPSearchResultController.h"

@import LMGeocoder;

#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "ZPPAddress.h"
#import "ZPPAddressHelper.h"
#import "ZPPConsts.h"

static NSString *ZPPSearchResultCellIdentifier = @"ZPPSearchResultCellIdentifier";

@interface ZPPSearchResultController () <UISearchBarDelegate>

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) NSString *initialAddressString;

@end

@implementation ZPPSearchResultController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIEdgeInsets insets = self.tableView.contentInset;
    self.tableView.contentInset =
        UIEdgeInsetsMake(insets.top + 20, insets.left, insets.bottom, insets.right);
    
    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self setCustomNavigationBackButtonWithTransition];


    self.searchBar.delegate = self;
    self.searchBar.tintColor = [UIColor blackColor];
    
    [self.tableView setRowHeight:UITableViewAutomaticDimension];
    self.tableView.estimatedRowHeight = 60;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.searchBar becomeFirstResponder];
    [self.searchBar setText:self.initialAddressString];
}

- (void)configureWithAddress:(ZPPAddress *)address {
    self.initialAddressString = [address formatedDescr];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.results.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ZPPSearchResultCellIdentifier];

    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:ZPPSearchResultCellIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;

    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];

    ZPPAddress *address = self.results[indexPath.row];

    cell.textLabel.text = [address formatedDescr];
    cell.textLabel.numberOfLines = 0;

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPAddress *address = self.results[indexPath.row];

    if ([self.searchBar.text isEqualToString: address.address]) {
        [self searchBarSearchButtonClicked:self.searchBar];
    } else {
        self.searchBar.text = address.address;
        [self searchWithText:address.address];
    }
}

#pragma mark - Search delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    ZPPAddress *address = self.results.lastObject;

    if (self.addressSearchDelegate && address) {
        [self.addressSearchDelegate configureWithAddress:address sender:self];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - Address searching

- (void)searchWithText:(NSString *)text {
    if (!text || text.length < 3) {
        return;
    }
    
    NSString *searchText = [NSString stringWithFormat: @"Москва %@", text];
    
    [[LMGeocoder sharedInstance] geocodeAddressString:searchText
                                              service:kLMGeocoderGoogleService
                                    completionHandler:^(NSArray *results, NSError *error) {
                                        self.results = [self convertResultsToAddresses:results];
                                        [self.tableView reloadData];
                                    }];
}

- (NSArray *)convertResultsToAddresses:(NSArray *)results {
    NSMutableArray *addresses = [NSMutableArray array];
    if (results) {
        for (int i = 0; i < results.count; i++) {
            LMAddress *address = results[i];
            ZPPAddress *zpAddress = [ZPPAddressHelper addresFromAddres:address];
            if (zpAddress) {
                [addresses addObject:zpAddress];
            }
        }
    }
    
    return [NSArray arrayWithArray:addresses];
}

@end
