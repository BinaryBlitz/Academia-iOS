//
//  Category.h
//  Academia
//
//  Created by Алексей on 03.04.17.
//  Copyright © 2017 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPCategory : NSObject

@property (strong, nonatomic) NSNumber *_id;
@property (strong, nonatomic) NSString *name;
@property (assign, nonatomic) BOOL complementary;

- (instancetype)initWithIdentificator:(NSNumber *)identificator
                                 name:(NSString *)name
                                 complementary:(BOOL)complementary;

@end
