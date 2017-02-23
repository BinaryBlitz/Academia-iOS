//
//  ZPPStarsCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 28/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPStarsCell.h"
//#import <HCSStarRatingView.h>

@import HCSStarRatingView;

@implementation ZPPStarsCell

- (void)awakeFromNib {
  // Initialization code
  [super awakeFromNib];
  self.starView.backgroundColor = [UIColor clearColor];
  self.starView.allowsHalfStars = NO;
  self.starView.continuous = NO;

  self.starView.tintColor = [UIColor blackColor]; //[UIColor colorWithRed:1 green:215.0/255.0 blue:0 alpha:1.0];

  self.starView.minimumValue = -1.f;

//    NSDictionary *underlineAttribute =
//    @{ NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle) };
//    NSAttributedString *attrStr =
//    [[NSAttributedString alloc] initWithString:self.actionButton.titleLabel.text
//                                    attributes:underlineAttribute];
//
//    [self.actionButton setAttributedTitle:attrStr forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
