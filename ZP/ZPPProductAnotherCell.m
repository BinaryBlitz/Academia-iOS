//
//  ZPPProductAnotherCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductAnotherCell.h"

#import <JSBadgeView.h>

@interface ZPPProductAnotherCell ()

@property (strong, nonatomic) JSBadgeView *badgeView;


@end

@implementation ZPPProductAnotherCell

//-(void)layoutSubviews {
//    [super layoutSubviews];
//    self.pictureImageView.layer.cornerRadius = self.pictureImageView.bounds.size.height/2.0;
//    self.pictureImageView.layer.masksToBounds = YES;
//}

- (void)awakeFromNib {
    // Initialization code
    
    self.badgeView =
    [[JSBadgeView alloc] initWithParentView:self.addProductButton alignment:JSBadgeViewAlignmentTopRight];
}

-(void)drawRect:(CGRect)rect {
    self.pictureImageView.layer.cornerRadius = self.pictureImageView.bounds.size.height/2.0;
    self.pictureImageView.layer.masksToBounds = YES;
}


- (void)setBadgeCount:(NSInteger )badgeCount {
    if(badgeCount){
        self.badgeView.badgeText = [NSString stringWithFormat:@"%@",@(badgeCount)];
    } else {
        self.badgeView.badgeText = nil;
    }
}


@end
