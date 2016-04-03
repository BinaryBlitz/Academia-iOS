//
//  ZPPAdressHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAddressHelper.h"

@import LMGeocoder;
#import "ZPPAddress.h"

@implementation ZPPAddressHelper

+ (ZPPAddress *)addresFromAddres:(LMAddress *)addr {
    NSString *route = [self component:@"route" inArray:addr.lines ofType:@"short_name"];
    NSString *streetName = nil;
    if (route && addr.thoroughfare) {
        streetName = [NSString stringWithFormat:@"%@, %@", route, addr.thoroughfare];
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

+ (NSString *)component:(NSString *)component inArray:(NSArray *)array ofType:(NSString *)type {
    NSInteger index = [array indexOfObjectPassingTest:^(id obj, NSUInteger idx, BOOL *stop) {
        return [(NSString *)([[obj objectForKey:@"types"] firstObject]) isEqualToString:component];
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

    ZPPAddress *a =
        [[ZPPAddress alloc] initWithCoordinate:loc Country:nil city:nil address:address];

    return a;
}

+ (NSArray *)parsePoints:(NSArray *)points {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in points) {
        NSNumber *lat = d[@"latitude"];
        NSNumber *lon = d[@"longitude"];

        if ([lat isEqual:[NSNull null]] || [lon isEqual:[NSNull null]]) {
            continue;
        }
        CLLocationCoordinate2D c = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);

        ZPPAddress *adr =
            [[ZPPAddress alloc] initWithCoordinate:c Country:nil city:nil address:nil];

        [tmp addObject:adr];
    }
    return [NSArray arrayWithArray:tmp];
}

+ (NSArray *)addressesFromDaDataDicts:(NSArray *)dicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in dicts) {
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

    ZPPAddress *a =
        [[ZPPAddress alloc] initWithCoordinate:c Country:nil city:nil address:unrestricted_value];		
		
    return a;		
}

@end
