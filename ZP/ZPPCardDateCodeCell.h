//
//  ZPPCardDateCodeCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BKCardExpiryField;

@interface ZPPCardDateCodeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BKCardExpiryField *dateTextField;
@property (weak, nonatomic) IBOutlet UITextField *cvcTextField;

@end
