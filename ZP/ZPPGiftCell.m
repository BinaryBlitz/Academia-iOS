//
//  ZPPGiftCell.m
//  ZP
//
//  Created by Andrey Mikhaylov on 03/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPGiftCell.h"
#import "ZPPGift.h"

//#import <JSBadgeView.h>

#import "ZPPConsts.h"

@import JSBadgeView;

@interface ZPPGiftCell ()

@property (strong, nonatomic) JSBadgeView *badgeView;

@end

@implementation ZPPGiftCell

- (void)awakeFromNib {
  // Initialization code
  [super awakeFromNib];
  self.badgeView = [[JSBadgeView alloc] initWithParentView:self.addButton
                                                 alignment:JSBadgeViewAlignmentTopRight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)configureWithGift:(ZPPGift *)gift {
  self.nameLabel.text = gift.name;
  self.giftDescriptionLabel.text = gift.giftDescription;
  self.priceLabel.text = [NSString stringWithFormat:@"%@%@", gift.price, ZPPRoubleSymbol];
}

- (void)setBadgeCount:(NSInteger)badgeCount {
  if (badgeCount) {
    self.badgeView.badgeText = [NSString stringWithFormat:@"%@", @(badgeCount)];
  } else {
    self.badgeView.badgeText = nil;
  }
}

@end
