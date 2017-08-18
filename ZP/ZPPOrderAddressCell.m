#import "ZPPOrderAddressCell.h"
#import "ZPPAddress.h"

@implementation ZPPOrderAddressCell

- (void)configureWithAddress:(ZPPAddress *)address {
  self.addresDescrLabel.text = @"Адрес доставки";
  self.addresLabel.text = [NSString stringWithFormat:@"%@", [address formattedDescription]];
  //   [self.chooseAnotherButton setTitle:@"Выбрать другой адерс" forState:UIControlStateNormal];

  NSDictionary *underlineAttribute =
      @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
  NSAttributedString *attrStr =
      [[NSAttributedString alloc] initWithString:@"Выбрать другой адрес"
                                      attributes:underlineAttribute];

  [self.chooseAnotherButton setAttributedTitle:attrStr forState:UIControlStateNormal];
}

@end
