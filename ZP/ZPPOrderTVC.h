//
//  ZPPOrderTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 30/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;

@class ZPPOrder;

@interface ZPPOrderTVC : UITableViewController

@property (strong, nonatomic, readonly) ZPPOrder *order;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
