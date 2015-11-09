//
//  ZPPMenuView.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPMainMenuView : UIView

@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@property (weak, nonatomic) IBOutlet UIButton *promoButton;
@property (weak, nonatomic) IBOutlet UIButton *giftCardButton;
@property (weak, nonatomic) IBOutlet UIButton *ordersButton;
@property (weak, nonatomic) IBOutlet UIButton *helpButton;
@property (weak, nonatomic) IBOutlet UIButton *myCardsButton;


- (void)showCompletion:(void (^)())completion;
- (void)dismissCompletion:(void (^)())completion;

@end
