//
//  ZPPCommentCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 29/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCommentCell.h"
#import "UIView+UIViewCategory.h"

@implementation ZPPCommentCell

- (void)awakeFromNib {
    // Initialization code
    [self.actionButton makeBordered];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
