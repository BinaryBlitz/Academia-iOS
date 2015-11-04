//
//  ZPPGiftTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPPOrder;

@interface ZPPGiftTVC : UITableViewController

- (void)configureWithOrder:(ZPPOrder *)order;

@end
