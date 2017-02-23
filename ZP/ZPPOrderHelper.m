#import "ZPPOrderHelper.h"
#import "ZPPOrder.h"
#import "ZPPDish.h"
#import "ZPPAddress.h"
#import "ZPPOrderItem.h"
#import "ZPPAddressHelper.h"
#import "ZPPDishHelper.h"

#import "NSDate+ZPPDateCategory.h"

@implementation ZPPOrderHelper

+ (NSDictionary *)orderDictFromOrder:(ZPPOrder *)order {
  NSMutableDictionary *dict = [NSMutableDictionary dictionary];

  dict[@"address"] = [order.address formattedDescription];
  NSMutableArray *tmpArr = [NSMutableArray array];
  for (ZPPOrderItem *oi in order.items) {
    NSDictionary *d = @{@"dish_id": oi.item.identifierOfItem, @"quantity": @(oi.count)};
    [tmpArr addObject:d];
  }
  dict[@"line_items_attributes"] = [NSArray arrayWithArray:tmpArr];
  dict[@"latitude"] = @(order.address.coordinate.latitude);
  dict[@"longitude"] = @(order.address.coordinate.longitude);

  if (!order.deliverNow) {
    dict[@"scheduled_for"] = [order.date serverFormattedString];
  }

  return [NSDictionary dictionaryWithDictionary:dict];
}

+ (ZPPOrder *)parseOrderFromDict:(NSDictionary *)dict {
  NSString *identifier = dict[@"id"];

  NSString *review;

  if (dict[@"review"] && ![dict[@"review"] isEqual:[NSNull null]]) {
    review = dict[@"review"];
  }

  float rating = 0;
  if (dict[@"rating"] && ![dict[@"rating"] isEqual:[NSNull null]]) {
    rating = [dict[@"rating"] floatValue];
  }

  NSArray *lineAttributes = dict[@"line_items"];

  NSMutableArray *tmp = [NSMutableArray array];
  for (NSDictionary *d in lineAttributes) {
    ZPPOrderItem *oi = [[self class] orderItemFromDict:d];
    [tmp addObject:oi];
  }

  NSString *dateString = dict[@"created_at"];

  NSDate *date = [NSDate customDateFromString:dateString];

  ZPPAddress *address = [ZPPAddressHelper addressFromDict:dict];
  ZPPOrderStatus status = [[self class] statusForString:dict[@"status"]];

  ZPPOrder *order = [[ZPPOrder alloc] initWithIdentifier:identifier
                                                   items:tmp
                                                 address:address
                                             orderStatus:status
                                                    date:date
                                                  review:review
                                                  rating:rating];

  return order;
}

+ (ZPPOrderStatus)statusForString:(NSString *)statusString {
  ZPPOrderStatus status = ZPPOrderStatusNew;
  if ([statusString isEqualToString:@"new"]) {
    status = ZPPOrderStatusNew;
  } else if ([statusString isEqualToString:@"rejected"]) {
    status = ZPPOrderStatusRejected;
  } else if ([statusString isEqualToString:@"delivered"]) {
    status = ZPPOrderStatusDelivered;
  } else if ([statusString isEqualToString:@"on_the_way"]) {
    status = ZPPOrderStatusOnTheWay;
  }

  return status;
}

+ (ZPPOrderItem *)orderItemFromDict:(NSDictionary *)dict {
  ZPPDish *d = [ZPPDishHelper dishFromDict:dict[@"dish"]];
  NSInteger count = [dict[@"quantity"] integerValue];

  ZPPOrderItem *orderItem = [[ZPPOrderItem alloc] initWithItem:d count:count];

  return orderItem;
}

+ (NSArray *)parseOrdersFromDicts:(NSArray *)dicts {
  NSMutableArray *temp = [NSMutableArray array];

  for (NSDictionary *d in dicts) {
    ZPPOrder *order = [[self class] parseOrderFromDict:d[@"order"]];

    [temp addObject:order];
  }

  return [NSArray arrayWithArray:temp];
}

@end
