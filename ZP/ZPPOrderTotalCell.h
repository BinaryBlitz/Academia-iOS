//
//  ZPPOrderTotalCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 05/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPPOrder;
@interface ZPPOrderTotalCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
