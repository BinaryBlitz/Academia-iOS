//
//  ZPPDish.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"
#import "ZPPWithImageURL.h"

@class ZPPEnergy;

@interface ZPPDish : NSObject <ZPPItemProtocol,ZPPWithImageURL>

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *dishID;
@property (copy, nonatomic, readonly) NSString *subtitle;
@property (copy, nonatomic, readonly) NSString *dishDescription;
@property (copy, nonatomic, readonly) NSNumber *price;
@property (copy, nonatomic, readonly) NSString *urlAsString;
@property (strong, nonatomic, readonly) NSArray *ingridients;
@property (strong, nonatomic, readonly) NSArray *badges;
@property (assign, nonatomic, readonly) BOOL isNoItems;

@property (strong, nonatomic, readonly) ZPPEnergy *energy;

- (instancetype)initWithName:(NSString *)name
                      dishID:(NSString *)dishID
                    subtitle:(NSString *)subtitle
             dishDescription:(NSString *)dishDescription
                       price:(NSNumber *)price
                      imgURL:(NSString *)urlAsString
                 ingridients:(NSArray *)ingridients
                      badges:(NSArray *)badges
                     noItems:(BOOL)noItems
                      energy:(ZPPEnergy *)energy;

- (NSInteger)priceOfItem;
- (NSString *)nameOfItem;

@end
