//
//  ZPPStarsCell.h
//  ZP
//
//  Created by Andrey Mikhaylov on 28/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HCSStarRatingView;

@interface ZPPStarsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;


@end
