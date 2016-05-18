//
//  ZPPSearchResultController.m
//  ZP
//
//  Created by Andrey Mikhaylov on 11/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPSearchResultController.h"

@import LMGeocoder;
#import <IDDaDataSuggestions/IDDaDataSuggestions.h>

#import "UINavigationController+ZPPNavigationControllerCategory.h"
#import "UIViewController+ZPPViewControllerCategory.h"
#import "UITableViewController+ZPPTVCCategory.h"
#import "ZPPAddress.h"
#import "ZPPAddressHelper.h"
#import "ZPPConsts.h"

static NSString *ZPPSearchResultCellIdentifier = @"ZPPSearchResultCellIdentifier";

static NSString *ZPPDaDataAPIKey = @"bfdacc45560db9c73425f30f5c630842e5c8c1ad";

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
    
    [[IDDaDataSuggestions sharedInstance] setBaseURL:@"https://dadata.ru/api/v2/" apiKey:ZPPDaDataAPIKey];
    
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
        [[LMGeocoder sharedInstance] geocodeAddressString:address.address
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(NSArray *results, NSError *error) {
                                            ZPPAddress *bestResult = [ZPPAddressHelper addresFromAddres:results.lastObject];
                                            if (bestResult) {
                                                [self.addressSearchDelegate configureWithAddress:bestResult sender:self];
                                                [self dismissViewControllerAnimated:YES completion:nil];
                                            } else {
                                                [self presentAlertWithMessage:@"Адрес введен неверно. Попробуйте ещё раз"];
                                                [searchBar setText:nil];
                                                [searchBar becomeFirstResponder];
                                            }
                                        }];
    }
}

- (void)presentAlertWithMessage:(NSString *)message {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil
                                                                   message:message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - Address searching

- (void)searchWithText:(NSString *)text {
    if (!text || text.length < 3) {
        return;
    }
    
    [[IDDaDataSuggestions sharedInstance] getAddressSuggestionsForString:text
                                                            restrictions: @[@{@"region": @"москва"}]
                                                 hideRestrictionInResult:NO
                                                                 success:^(NSArray *suggestions) {
                                                                     NSArray *addresses = [ZPPAddressHelper addressesFromDaDataDicts:suggestions];
                                                                     self.results = addresses;
                                                                     [self.tableView reloadData];
                                                                 }
                                                                 failure:^(NSError *error) {
                                                                     
                                                                 }];
}

@end
