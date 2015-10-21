//
//  ZPPRegistrationSuccesVC.h
//  ZP
//
//  Created by Andrey Mikhaylov on 18/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPPUser;
@interface ZPPRegistrationSuccesVC : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *greatingLabel;

-(void)setUser:(ZPPUser *)user ;

@end
