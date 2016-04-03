//
//  ZPPAddressDelegate.h
//  ZP
//
//  Created by Dan Shevlyuk on 03/04/2016.
//  Copyright © 2016 BinaryBlitz. All rights reserved.
//

@import Foundation;

@class ZPPAddress;
@protocol ZPPAddressDelegate <NSObject>

- (void)configureWithAddress:(ZPPAddress *)address sender:(id)sender;

@end