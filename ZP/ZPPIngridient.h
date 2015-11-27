//
//  ZPPIngridient.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZPPWithImageURL.h"

@interface ZPPIngridient : NSObject <ZPPWithImageURL>

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *ingridientID;
@property (copy, nonatomic, readonly) NSString *urlAsString;
@property (strong, nonatomic, readonly) NSNumber *weight;

- (instancetype)initWithName:(NSString *)name
                ingridientID:(NSString *)ingridientID
                 urlAsString:(NSString *)urlAsString
                      weight:(NSNumber *)weight;

@end
