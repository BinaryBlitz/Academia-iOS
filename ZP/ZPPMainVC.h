//
//  ZPPMainVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "ZPPBeginScreenTVC.h"
#import "ZPPItemProtocol.h"

@interface ZPPMainVC : UIViewController //<ZPPBeginScreenTVCDelegate>

- (void)showRegistration;

- (void)addItemIntoOrder:(id<ZPPItemProtocol>)item;
@end
