#import "ZPPOrderHistoryCell.h"
#import "ZPPOrder.h"

#import "ZPPConsts.h"
//#import <DateTools.h>
@import DateTools;

@implementation ZPPOrderHistoryCell

- (void)configureWithOrder:(ZPPOrder *)order {
  NSString *dateString =
      [NSString stringWithFormat:@"Заказ от %ld.%ld.%ld", (long) [order.date day], (long) [order.date month], (long) [order.date year]];
  self.orderName.text = dateString;

  self.descrLabel.text = [order orderDescr];  // descrString;

//    [order totalPriceWithDelivery]
  self.priceLabel.text = [NSString
      stringWithFormat:@"На сумму: %@%@", @([order totalPriceWithDelivery]), ZPPRoubleSymbol];
}

@end
