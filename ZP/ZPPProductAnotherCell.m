//
//  ZPPProductAnotherCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductAnotherCell.h"

@implementation ZPPProductAnotherCell

-(void)layoutSubviews {
    [super layoutSubviews];
    self.pictureImageView.layer.cornerRadius = self.pictureImageView.bounds.size.height/2.0;
    self.pictureImageView.layer.masksToBounds = YES;
}

@end
