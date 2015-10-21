//
//  ZPPIngridient.h
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPIngridient : NSObject

@property (copy, nonatomic, readonly) NSString *name;
@property (copy, nonatomic, readonly) NSString *ingridientID;
@property (copy, nonatomic, readonly) NSString *urlAsString;

- (instancetype)initWithName:(NSString *)name
                ingridientID:(NSString *)ingridientID
                 urlAsString:(NSString *)urlAsString;

@end
