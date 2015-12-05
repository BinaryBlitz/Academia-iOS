//
//  ZPPAdressHelper.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAddressHelper.h"

#import "LMGeocoder.h"
#import "ZPPAddress.h"

@implementation ZPPAddressHelper

+ (ZPPAddress *)addresFromAddres:(LMAddress *)addr {
    NSString *street = nil;
    for (NSDictionary *d in addr.lines) {
        NSArray *arr = d[@"types"];
        if (arr && ![arr isEqual:[NSNull null]]) {
            if ([arr containsObject:@"route"]) {
                street = d[@"short_name"];
                break;
            }
        }
    }
    if (street && addr.thoroughfare) {
        street = [NSString stringWithFormat:@"%@, %@", street, addr.thoroughfare];
    }

    ZPPAddress *address = [[ZPPAddress alloc] initWithCoordinate:addr.coordinate
                                                         Country:addr.country
                                                            city:addr.locality
                                                         address:street];

    return address;
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

+ (NSArray *)addressesFromFoursquareDict:(id)responseObject {
    NSDictionary *respDict = responseObject[@"response"];

    NSMutableArray *tmpArr = [NSMutableArray array];
    if (respDict && ![respDict isEqual:[NSNull null]]) {
        NSArray *venues = respDict[@"venues"];
        for (NSDictionary *venue in venues) {
            ZPPAddress *a = [[self class] addresFromFoursquareDict:venue];
            [tmpArr addObject:a];
        }
        return [NSArray arrayWithArray:tmpArr];
    }

    return [NSArray array];
}

+ (ZPPAddress *)addresFromFoursquareDict:(NSDictionary *)dict {
    NSDictionary *locationDict = dict[@"location"];
    double lat = [locationDict[@"lat"] doubleValue];
    double lon = [locationDict[@"lng"] doubleValue];

    CLLocationCoordinate2D c = CLLocationCoordinate2DMake(lat, lon);
    NSString *country = locationDict[@"country"];
    NSString *city = locationDict[@"city"];
    NSArray *formattedAddresses = locationDict[@"formattedAddress"];

    NSString *address = [formattedAddresses componentsJoinedByString:@" "];

    ZPPAddress *a =
        [[ZPPAddress alloc] initWithCoordinate:c Country:country city:city address:address];

    return a;
}

+ (NSArray *)addressesFromDaDataDicts:(NSArray *)dicts {
    NSMutableArray *tmp = [NSMutableArray array];
    for (NSDictionary *d in dicts) {
        //     NSDictionary *geoDict = d[@"data"];

        //        if([geoDict[@"geo_lat"] isEqual:[NSNull null]]) {
        //            continue;
        //        }

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

@end
