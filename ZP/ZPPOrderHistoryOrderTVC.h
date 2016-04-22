//
//  ZPPOrderHistoryOrderTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;

@class ZPPOrder;

@interface ZPPOrderHistoryOrderTVC: UITableViewController

@property (strong, nonatomic, readonly) ZPPOrder *order;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
