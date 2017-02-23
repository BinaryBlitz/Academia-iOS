#import "ZPPNoCreditCardCell.h"

@implementation ZPPNoCreditCardCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code

//    self.layer.borderColor = [UIColor blackColor].CGColor;
//    self.layer.borderWidth = 2.0f;
}

- (void)drawRect:(CGRect)rect {
  self.actionButton.layer.borderColor = [UIColor blackColor].CGColor;
  self.actionButton.layer.borderWidth = 2.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
