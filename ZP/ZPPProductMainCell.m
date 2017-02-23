//
//  ZPPProductMainCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductMainCell.h"

@implementation ZPPProductMainCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)drawRect:(CGRect)rect {
  UIView *view = self.productImageView;
  if (![[view.layer.sublayers firstObject] isKindOfClass:[CAGradientLayer class]]) {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;

    gradient.endPoint = CGPointMake(0.5, 0);
    gradient.startPoint = CGPointMake(0.5, 0.3);

    gradient.colors =
        [NSArray arrayWithObjects:(id) [[UIColor clearColor] CGColor],
                                  (id) [[UIColor colorWithWhite:0 alpha:0.5] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
  }
}

@end
