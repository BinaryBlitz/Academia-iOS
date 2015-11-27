//
//  ZPPBadgeCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 26/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZPPBadgeCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *badgesImageViews;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *badgesLabels;

@end
