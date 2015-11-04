//
//  ZPPOrderHistoryTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPPOrder;

@interface ZPPOrderHistoryTVC : UITableViewController

- (void)configureWithOrder:(ZPPOrder *)order;//redo

@end
