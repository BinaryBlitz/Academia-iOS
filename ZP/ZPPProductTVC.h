//
//  ZPPProductTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductsBaseTVC.h"
#import "ZPPItemProtocol.h"

@class ZPPDish;

//@protocol ZPPProductScreenTVCDelegate <NSObject>   //define delegate protocol
//- (void) addItemIntoOrder:(id<ZPPItemProtocol>)item;  //define delegate method to be implemented within another class
//@end //end protocol

@interface ZPPProductTVC : ZPPProductsBaseTVC

//@property (nonatomic, weak) id <ZPPProductScreenTVCDelegate> productDelegate;

//@property (assign, nonatomic) NSInteger specindex;
-(void)configureWithDish:(ZPPDish *) dish;

@end
