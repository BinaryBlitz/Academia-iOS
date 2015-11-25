//
//  ZPPAddress.m
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPAddress.h"

@interface ZPPAddress ()

@property (assign, nonatomic) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic) NSString *country;
@property (strong, nonatomic) NSString *city;
@property (strong, nonatomic) NSString *addres;

@end

@implementation ZPPAddress

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D )coordinate
                           Country:(NSString *)country
                              city:(NSString *)city
                           address:(NSString *)address {
    self = [super init];
    if (self) {
        self.coordinate = coordinate;
        self.city = city;
        self.country = country;
        self.addres = address;
    }
    return self;
}

- (NSString *)formatedDescr {
    return [NSString  stringWithFormat:@"%@", self.addres];
}

@end
