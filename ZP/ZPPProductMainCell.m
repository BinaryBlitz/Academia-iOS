#import "ZPPProductMainCell.h"

@implementation ZPPProductMainCell

- (void)awakeFromNib {
  [super awakeFromNib];
  // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
  [super setSelected:selected animated:animated];

  // Configure the view for the selected state
}

- (void)setTitle:(NSString*)title {
  self.nameLabel.attributedText=[[NSAttributedString alloc]
                             initWithString:title
                             attributes:@{
                                          NSStrokeWidthAttributeName: @-2.0,
                                          NSStrokeColorAttributeName:[UIColor blackColor],
                                          NSForegroundColorAttributeName:[UIColor whiteColor]
                                          }
                             ];
}

- (void)setPrice:(NSString *)title {
  self.priceLabel.attributedText=[[NSAttributedString alloc]
                                 initWithString:title
                                 attributes:@{
                                              NSStrokeWidthAttributeName: @-2.0,
                                              NSStrokeColorAttributeName:[UIColor blackColor],
                                              NSForegroundColorAttributeName:[UIColor whiteColor]
                                              }
                                 ];
}

- (void)setIngridientsDescription:(NSString *)title {
  self.ingridientsDescriptionLabel.attributedText=[[NSAttributedString alloc]
                                  initWithString:title
                                  attributes:@{
                                               NSStrokeWidthAttributeName: @-2.0,
                                               NSStrokeColorAttributeName:[UIColor blackColor],
                                               NSForegroundColorAttributeName:[UIColor whiteColor]
                                               }
                                  ];
}

- (void)drawRect:(CGRect)rect {
  UIView *view = self.productImageView;
  if (![[view.layer.sublayers firstObject] isKindOfClass:[CAGradientLayer class]]) {
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = view.bounds;

    gradient.endPoint = CGPointMake(0.5, 0);
    gradient.startPoint = CGPointMake(0.5, 0.3);

    gradient.colors =
        [NSArray arrayWithObjects:(id) [[UIColor clearColor] CGColor],
                                  (id) [[UIColor colorWithWhite:0 alpha:0.5] CGColor], nil];
    [view.layer insertSublayer:gradient atIndex:0];
  }
}

@end
