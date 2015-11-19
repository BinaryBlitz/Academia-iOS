//
//  ZPPProductTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductsBaseTVC.h"
#import "ZPPConfigureWithOrder.h"
//#import "ZPPItemProtocol.h"

@class ZPPDish;


//@protocol ZPPProductScreenTVCDelegate <NSObject>   //define delegate protocol
//- (void) addItemIntoOrder:(id<ZPPItemProtocol>)item;  //define delegate method to be implemented within another class
//@end //end protocol

@interface ZPPProductTVC : ZPPProductsBaseTVC <ZPPConfigureWithOrder>

//@property (nonatomic, weak) id <ZPPProductScreenTVCDelegate> productDelegate;

//@property (assign, nonatomic) NSInteger specindex;
- (void)configureWithOrder:(ZPPOrder *)order;
-(void)configureWithDish:(ZPPDish *) dish;

@end
