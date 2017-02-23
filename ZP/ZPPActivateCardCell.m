#import "ZPPActivateCardCell.h"
#import "UIView+UIViewCategory.h"

@implementation ZPPActivateCardCell

- (void)awakeFromNib {
  // Initialization code
  [super awakeFromNib];
  [self.codeTextField makeBordered];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
