//
//  ZPPProductMainCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPProductMainCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *ingridientsDescriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UIButton *addToBasketButton;

@end
