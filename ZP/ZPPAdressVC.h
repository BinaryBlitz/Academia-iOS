//
//  ZPPAdressVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 07/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import UIKit;

#import "ZPPAddressDelegate.h"

@interface ZPPAdressVC : UIViewController

@property (weak, nonatomic) id <ZPPAddressDelegate> addressDelegate;


@end
