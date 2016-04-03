//
//  ZPPAddress.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

@import Foundation;
@import MapKit;

@interface ZPPAddress: NSObject

@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic, readonly) NSString *country;
@property (strong, nonatomic, readonly) NSString *city;
@property (strong, nonatomic, readonly) NSString *address;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D )coordinate
                           Country:(NSString *)country
                              city:(NSString *)city
                           address:(NSString *)address;

- (NSString *)formatedDescr;


@end
