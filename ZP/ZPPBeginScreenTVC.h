//
//  ZPPBeginScreenTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductsBaseTVC.h"

@protocol ZPPBeginScreenTVCDelegate <NSObject>
- (void) didPressBeginButton;
@end


@interface ZPPBeginScreenTVC: ZPPProductsBaseTVC

@property (nonatomic, weak) id <ZPPBeginScreenTVCDelegate> beginDelegate;

@end
