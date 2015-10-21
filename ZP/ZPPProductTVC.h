//
//  ZPPProductTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductsBaseTVC.h"

@class ZPPDish;
@interface ZPPProductTVC : ZPPProductsBaseTVC

//@property (assign, nonatomic) NSInteger specindex;
-(void)configureWithDish:(ZPPDish *) dish;

@end
