//
//  ZPPCardDateCodeCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardDateCodeCell.h"
#import "UIView+UIViewCategory.h"

#import "BKCardExpiryField.h"

@implementation ZPPCardDateCodeCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.dateTextField makeBordered];
    [self.cvcTextField makeBordered];   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
