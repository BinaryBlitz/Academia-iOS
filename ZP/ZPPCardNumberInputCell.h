//
//  ZPPCardNumberInputCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BKCardNumberField;

@interface ZPPCardNumberInputCell : UITableViewCell
@property (weak, nonatomic) IBOutlet BKCardNumberField *cardNumberTextField;

@end
