//
//  ZPPProductsBaseTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

             //define class, so protocol can see MyClass
@protocol ZPPProductsBaseTVCDelegate <NSObject>   //define delegate protocol
- (void) didScroll: (UIScrollView *) sender;  //define delegate method to be implemented within another class
@end //end protocol

@interface ZPPProductsBaseTVC : UITableViewController
@property (nonatomic, weak) id <ZPPProductsBaseTVCDelegate> delegate;

@property (assign, nonatomic, readonly) CGFloat screenHeight;
- (void)registreCells;

@end
