//
//  ZPPAdressVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 07/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ZPPAddress;
@protocol ZPPAdressDelegate <NSObject>

- (void)configureWithAddress:(ZPPAddress *)address sender:(id)sender;

@end


@interface ZPPAdressVC : UIViewController


@property (weak, nonatomic) id<ZPPAdressDelegate> addressDelegate;


@end
