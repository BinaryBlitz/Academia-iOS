//
//  ZPPEnergy.m
//  ZP
//
//  Created by Andrey Mikhaylov on 10/12/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPEnergy.h"
@interface ZPPEnergy ()

@property (strong, nonatomic) NSNumber *fats;
@property (strong, nonatomic) NSNumber *kilocalories;
@property (strong, nonatomic) NSNumber *carbohydrates;
@property (strong, nonatomic) NSNumber *proteins;

@end

@implementation ZPPEnergy

- (instancetype)initWithFats:(NSNumber *)fats
            kilocalories:(NSNumber *)kilocalories
           carbohydrates:(NSNumber *)carbohydrates
                proteins:(NSNumber *)proteins {
    self = [super init];
    if (self) {


        self.fats = fats;
        self.kilocalories = kilocalories;
        self.carbohydrates = carbohydrates;
        self.proteins = proteins;

    }
    return self;
}

@end
