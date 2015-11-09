//
//  ZPPOrderAddressCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPPAddress;
@interface ZPPOrderAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *addresDescrLabel;
@property (weak, nonatomic) IBOutlet UILabel *addresLabel;
@property (weak, nonatomic) IBOutlet UIButton *chooseAnotherButton;


- (void)configureWithAddress:(ZPPAddress *)address;

@end
