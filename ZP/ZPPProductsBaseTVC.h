//
//  ZPPProductsBaseTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPPItemProtocol.h"

@protocol ZPPProductsBaseTVCDelegate <NSObject>
- (void) didScroll: (UIScrollView *) sender;

@end


@protocol ZPPProductScreenTVCDelegate <NSObject>
- (void) addItemIntoOrder:(id<ZPPItemProtocol>)item;
@end //

@interface ZPPProductsBaseTVC : UITableViewController
@property (nonatomic, weak) id <ZPPProductsBaseTVCDelegate> delegate;
@property (nonatomic, weak) id <ZPPProductScreenTVCDelegate> productDelegate;

@property (assign, nonatomic, readonly) CGFloat screenHeight;
- (void)registreCells;

@end
