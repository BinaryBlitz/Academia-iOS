#import "ZPPOrderItemCell.h"
#import "ZPPOrderItem.h"

@implementation ZPPOrderItemCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)configureWithOrderItem:(ZPPOrderItem *)orderItem {
  self.countLabel.text = [NSString stringWithFormat:@"%@ x", @(orderItem.count)];

  NSDictionary *underlineAttribute =
      @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
  NSAttributedString *attrStr =
      [[NSAttributedString alloc] initWithString:[orderItem.item nameOfItem]
                                      attributes:underlineAttribute];
  self.nameLabel.attributedText = attrStr;

  // self.nameLabel.text = [orderItem.item nameOfItem];
  self.priceLabel.text = [NSString stringWithFormat:@"%@₽", @([orderItem totalPrice])];
}

@end
