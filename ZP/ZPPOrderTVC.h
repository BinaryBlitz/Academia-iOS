//
//  ZPPOrderTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 30/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPPOrder;


@interface ZPPOrderTVC : UITableViewController


- (void)configureWithOrder:(ZPPOrder *)order;

@end
