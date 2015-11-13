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

@end
