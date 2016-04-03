//
//  ZPPSearchResultController.h
//  ZP
//
//  Created by Andrey Mikhaylov on 11/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZPPAddressDelegate.h"

@class ZPPAddress;

@interface ZPPSearchResultController : UITableViewController

@property (weak, nonatomic) id <ZPPAddressDelegate> addressSearchDelegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)setResults:(NSArray *)results;
- (void)configureWithAddress:(ZPPAddress *)address;

@end
