//
//  ZPPDish.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPDish : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *dishID;
@property (copy, nonatomic,readonly) NSString *dishDescription;
@property (copy, nonatomic, readonly) NSNumber *price;
@property (copy, nonatomic, readonly) NSString *urlAsString;
@property (strong, nonatomic, readonly) NSArray *ingridients;

- (instancetype)initWithName:(NSString *)name
                      dishID:(NSString *)dishID
             dishDescription:(NSString *)dishDescription
                       price:(NSNumber *)price
                      imgURL:(NSString *)urlAsString
                 ingridients:(NSArray *)ingridients;

@end
