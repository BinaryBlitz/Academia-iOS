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

    // self.results = [self testArr];  // test

    [self configureBackgroundWithImageWithName:ZPPBackgroundImageName];
    [self addPictureToNavItemWithNamePicture:ZPPLogoImageName];
    [self setCustomNavigationBackButtonWithTransition];

    UIEdgeInsets insets = self.tableView.contentInset;
    self.tableView.contentInset =
        UIEdgeInsetsMake(insets.top + 20, insets.left, insets.bottom, insets.right);

    self.searchBar.delegate = self;

    self.searchBar.tintColor = [UIColor blackColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.searchBar becomeFirstResponder];

    //   [self searchWithText:@"Россия"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    cell.textLabel.text = adr.addres;  // self.results[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZPPAddress *address = self.results[indexPath.row];

    if (![address isKindOfClass:[ZPPAddress class]]) {
        return;
    }

    self.searchBar.text = address.addres;
    [self searchWithText:address.addres];

    //    if (self.addressSearchDelegate) {
    //        [self.addressSearchDelegate configureWithAddress:address sender:self];
    //
    //        [self dismissViewControllerAnimated:YES completion:nil];
    //    }
}

//- (void)setResults:(NSArray *)results {
//    _results = [self testArr];
//}

#pragma mark - testData

//- (NSArray *)testArr {
//    // NSString *textString = [LoremIpsum wordsWithNumber:7];
//
//    NSArray *test = @[];  //[textString componentsSeparatedByString:@" "];
//
//    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(37, 57);
//
//    ZPPAddress *adr1 =
//        [[ZPPAddress alloc] initWithCoordinate:c Country:@"Russia" city:@"Moscow" address:@"a"];
//
//    test = @[ adr1 ];
//
//    return test;
//}

#pragma mark - search delegate

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchWithText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    if (self.addressSearchDelegate) {
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        [[ZPPMapSearcher shared] searcDaDataWithAddress:searchBar.text
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

        //[self.addressSearchDelegate configureWithAddress:address sender:self];

      //  [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - server

- (void)searchWithText:(NSString *)text {
    if (!text || text.length < 3) {
//        self.searchBar.text = @"";
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

    //    [[ZPPMapSearcher shared] searchAddres:text
    //        onSuccess:^(NSArray *addresses) {
    //
    //            self.results = addresses;
    //            [self.tableView reloadData];
    //        }
    //        onFailure:^(NSError *error, NSInteger statusCode){
    //
    //        }];
}

@end
