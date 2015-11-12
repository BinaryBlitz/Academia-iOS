//
//  ZPPCardViewController.h
//  ZP
//
//  Created by Andrey Mikhaylov on 02/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>


@class ZPPCreditCard;

@protocol ZPPCardDelegate <NSObject>

- (void)configureWithCard:(ZPPCreditCard *)card sender:(id)sender;

@end

@interface ZPPCardViewController : UITableViewController

@property (weak, nonatomic) id <ZPPCardDelegate> cardDelegate;

@end
