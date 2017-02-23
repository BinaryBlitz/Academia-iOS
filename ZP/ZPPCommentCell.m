#import "ZPPCommentCell.h"
#import "UIView+UIViewCategory.h"

@implementation ZPPCommentCell

- (void)awakeFromNib {
  // Initialization code
  [super awakeFromNib];
  [self.actionButton makeBordered];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
