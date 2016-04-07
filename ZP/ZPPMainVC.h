//
//  ZPPMainVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;

#import "ZPPItemProtocol.h"

@class ZPPOrder;

@interface ZPPMainVC : UIViewController

@property (strong, nonatomic) ZPPOrder *order;

- (void)showRegistration;
- (void)addItemIntoOrder:(id<ZPPItemProtocol>)item;
- (void)showNoInternetScreen;

@end
