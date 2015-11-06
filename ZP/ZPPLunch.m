//
//  ZPPLunch.m
//  ZP
//
//  Created by Andrey Mikhaylov on 06/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPLunch.h"

@interface ZPPLunch ()

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSNumber *lunchIdentifier;
@property (strong, nonatomic) NSString *lunchDescription;
@property (strong, nonatomic) NSString *subtitle;
@property (strong, nonatomic) NSNumber *price;
@property (strong, nonatomic) NSURL *imgURL;

@end

@implementation ZPPLunch

- (instancetype)initWithName:(NSString *)name
                  identifier:(NSNumber *)identifier
                    subtitle:(NSString *)subtitle
                       descr:(NSString *)descr
                       price:(NSNumber *)price
                      imgURL:(NSURL *)imgUrl
{
    self = [super init];
    if (self) {
        self.name = name;
        self.subtitle = subtitle;
        self.lunchDescription = descr;
        self.price = price;
        self.imgURL = imgUrl;
    }
    return self;
}

//- (instancetype)initWithDict:(NSDictionary *)dict {
//    self = [super init];
//    if (self) {
//        self.name = dict[@"name"];
//        self.subtitle = dict[@"subtitle"];
//        self.price = dict[@"price"];
//        self.lunchDescription = dict[@"description"];
//    }
//    return self;
//}

- (NSString *)nameOfItem {
    return self.name;
}

- (NSInteger)priceOfItem {
    return self.price.integerValue;
}

@end
