//
//  ZPPCardInputTVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPPCreditCard;

@protocol ZPPNewCreditCardDelegate <NSObject>

- (void)cardCreated:(ZPPCreditCard *)card sender:(id)sender;

@end


@interface ZPPCardInputTVC : UITableViewController

@property (weak, nonatomic) id <ZPPNewCreditCardDelegate> cardCreateDelegate;

@end
