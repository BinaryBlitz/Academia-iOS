//
//  ZPPProductAnotherCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 08/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPProductAnotherCell.h"
#import "ZPPStuff.h"

#import "ZPPUserManager.h"
#import "ZPPUser.h"

//#import <UIImageView+AFNetworking.h>
//
//#import <JSBadgeView.h>
#import "ZPPConsts.h"

@import JSBadgeView;
@import AFNetworking;
@import SDWebImage;

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

- (void)configureWithStuff:(ZPPStuff *)stuff {
    
    self.nameLabel.text = stuff.name;
    self.productDescriptionLabel.text = stuff.stuffDescr;
    self.priceLabel.text = [NSString stringWithFormat:@"%@%@", stuff.price, ZPPRoubleSymbol];
    
//    [self.pictureImageView setImageWithURL:stuff.imgURl];
    
    [self.pictureImageView sd_setImageWithURL:stuff.imgURl];
    
    if([ZPPUserManager sharedInstance].user.apiToken) {
        self.addProductButton.hidden = NO;
    } else {
        self.addProductButton.hidden = YES;
    }
}


- (void)setBadgeCount:(NSInteger )badgeCount {
    if(badgeCount){
        self.badgeView.badgeText = [NSString stringWithFormat:@"%@",@(badgeCount)];
    } else {
        self.badgeView.badgeText = nil;
    }
}


@end
