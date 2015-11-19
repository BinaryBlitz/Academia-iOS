//
//  ZPPAnotherProductsTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductsBaseTVC.h"
#import "ZPPConfigureWithOrder.h"

@class ZPPOrder;
@interface ZPPAnotherProductsTVC : ZPPProductsBaseTVC <ZPPConfigureWithOrder>



- (void)configureWithStuffs:(NSArray *)stuffs;
- (void)configureWithOrder:(ZPPOrder *)order;

//- (void)configureWithStuffs:(NSArray *)stuffs order:(ZPPOrder *)order;


@end
