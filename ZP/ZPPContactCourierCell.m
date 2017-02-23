#import "ZPPContactCourierCell.h"

@implementation ZPPContactCourierCell

- (void)awakeFromNib {
  // Initialization code
  [super awakeFromNib];
  NSDictionary *underlineAttribute = @{
      NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle),
      NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-Medium" size:18.f]
  };
  NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.phoneNumber.text
                                                                attributes:underlineAttribute];

  self.phoneNumber.attributedText = attrStr;
  self.phoneNumber.textAlignment = NSTextAlignmentCenter;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

@end
