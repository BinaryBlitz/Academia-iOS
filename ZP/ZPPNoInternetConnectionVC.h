//
//  ZPPNoInternetConnectionVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZPPNoInternetDelegate <NSObject>

- (void)tryAgainSender:(id)sender;

@end

@interface ZPPNoInternetConnectionVC : UIViewController

@property (weak, nonatomic) id <ZPPNoInternetDelegate> noInternetDelegate;
@property (weak, nonatomic) IBOutlet UIButton *tryAgainButton;
@property (weak, nonatomic) IBOutlet UIImageView *centralLogo;

@end
