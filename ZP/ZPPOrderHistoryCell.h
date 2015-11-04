//
//  ZPPOrderHistoryCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 04/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZPPOrder;

@interface ZPPOrderHistoryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderName;
@property (weak, nonatomic) IBOutlet UILabel *descrLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

- (void)configureWithOrder:(ZPPOrder *)order;

@end
