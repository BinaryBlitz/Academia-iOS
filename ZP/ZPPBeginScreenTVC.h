//
//  ZPPBeginScreenTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 16/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductsBaseTVC.h"


@protocol ZPPBeginScreenTVCDelegate <NSObject>   //define delegate protocol
- (void) didPressBeginButton;  //define delegate method to be implemented within another class
@end //end protocol


@interface ZPPBeginScreenTVC : ZPPProductsBaseTVC

@property (nonatomic, weak) id <ZPPBeginScreenTVCDelegate> beginDelegate;




@end
