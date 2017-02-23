#import "ZPPAddressHelper.h"

@import LMGeocoder;
#import "ZPPAddress.h"

@implementation ZPPAddressHelper

+ (ZPPAddress *)addressFromAddress:(LMAddress *)addr {
  NSString *route = [addr valueForKey:@"route"];
  NSString *streetName = nil;

  if (route && addr.streetNumber) {
    streetName = [NSString stringWithFormat:@"%@, %@", route, addr.streetNumber];
  } else if (route) {
    streetName = [NSString stringWithFormat:@"%@", route];
  } else {
    return nil;
  }

  ZPPAddress *address = [[ZPPAddress alloc] initWithCoordinate:addr.coordinate
                                                       Country:addr.country
                                                          city:addr.locality
                                                       address:streetName];

  return address;
}

+ (NSString *)component:(NSString *)component
                inArray:(NSArray *)array
                 ofType:(NSString *)type {

  NSInteger index = [array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
    return [(NSString *) ([[obj objectForKey:@"types"] firstObject]) isEqualToString:component];
  }];

  if (index == NSNotFound) {
    return nil;
  }

  if (index >= array.count) {
    return nil;
  }

  return [[array objectAtIndex:index] valueForKey:type];
}

+ (ZPPAddress *)addressFromDict:(NSDictionary *)dict {
  NSString *address = dict[@"address"];
  double lat = [dict[@"latitude"] doubleValue];
  double lon = [dict[@"longitude"] doubleValue];

  CLLocationCoordinate2D loc = CLLocationCoordinate2DMake(lat, lon);

  ZPPAddress *zppAddress = [[ZPPAddress alloc] initWithCoordinate:loc Country:nil city:nil address:address];

  return zppAddress;
}

+ (NSArray *)parsePoints:(NSArray *)points {
  NSMutableArray *tmp = [NSMutableArray array];

  for (NSDictionary *d in points) {
    NSNumber *latitude = d[@"latitude"];
    NSNumber *longitude = d[@"longitude"];

    if ([latitude isEqual:[NSNull null]] || [longitude isEqual:[NSNull null]]) {
      continue;
    }

    CLLocationCoordinate2D c = CLLocationCoordinate2DMake([latitude doubleValue], [longitude doubleValue]);

    ZPPAddress *address = [[ZPPAddress alloc] initWithCoordinate:c Country:nil city:nil address:nil];

    [tmp addObject:address];
  }
  return [NSArray arrayWithArray:tmp];
}

+ (NSArray *)addressesFromDaDataDictionaries:(NSArray *)dictionaries {
  NSMutableArray *tmp = [NSMutableArray array];
  for (NSDictionary *d in dictionaries) {
    ZPPAddress *a = [[self class] addresFromDaDataDict:d];

    [tmp addObject:a];
  }

  return [NSArray arrayWithArray:tmp];
}

+ (ZPPAddress *)addresFromDaDataDict:(NSDictionary *)dict {
  NSDictionary *locationDict = dict[@"data"];
  NSString *unrestricted_value = dict[@"unrestricted_value"];

  CLLocationCoordinate2D c = CLLocationCoordinate2DMake(0, 0);
  if (locationDict[@"geo_lat"] && ![locationDict[@"geo_lat"] isEqual:[NSNull null]]) {
    double lat = [locationDict[@"geo_lat"] doubleValue];
    double lon = [locationDict[@"geo_lon"] doubleValue];
    c = CLLocationCoordinate2DMake(lat, lon);
  }

  ZPPAddress *address = [[ZPPAddress alloc] initWithCoordinate:c Country:nil city:nil address:unrestricted_value];

  return address;
}

@end
