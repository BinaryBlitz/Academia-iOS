//
//  ZPPSearchResultController.h
//  ZP
//
//  Created by Andrey Mikhaylov on 11/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZPPAdressVC.h"

//@class ZPPAddress;

//@protocol ZPPAddressSearchDelegate <NSObject>
//
//- (void)configureWithAddress:(ZPPAddress *)address sender:(id)sender;
//
//@end


@interface ZPPSearchResultController : UITableViewController

@property (weak, nonatomic) id <ZPPAdressDelegate> addressSearchDelegate;

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

- (void)setResults:(NSArray *)results;

@end
