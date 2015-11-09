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
        street =
        [NSString stringWithFormat:@"%@, %@", street, addr.thoroughfare];
    }
    
    ZPPAddress *address = [[ZPPAddress alloc] initWithCoordinate:addr.coordinate
                                                         Country:addr.country
                                                            city:addr.locality
                                                         address:street];
    
    return address;
    
}

@end
