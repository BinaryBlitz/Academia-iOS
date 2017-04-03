#import "ZPPOrderAddressCell.h"
@import LMGeocoder;

@implementation ZPPOrderAddressCell

- (void)configureWithAddress:(LMAddress *)address {
  self.addresDescrLabel.text = @"Адрес доставки";
  self.addresLabel.text = [NSString stringWithFormat:@"%@, %@", [address route], [address streetNumber]];

  //   [self.chooseAnotherButton setTitle:@"Выбрать другой адерс" forState:UIControlStateNormal];

  NSDictionary *underlineAttribute =
      @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
  NSAttributedString *attrStr =
      [[NSAttributedString alloc] initWithString:@"Выбрать другой адрес"
                                      attributes:underlineAttribute];

  [self.chooseAnotherButton setAttributedTitle:attrStr forState:UIControlStateNormal];
}

@end
