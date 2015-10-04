//
//  ZPPProductsCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPProductsIngridientsCell : UITableViewCell
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *ingredientsImageViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *ingredientsLabels;

@end
