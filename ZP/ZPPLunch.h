//
//  ZPPLunch.h
//  ZP
//
//  Created by Andrey Mikhaylov on 06/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZPPItemProtocol.h"
#import "ZPPWithImageURL.h"

@interface ZPPLunch : NSObject <ZPPItemProtocol,ZPPWithImageURL>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSNumber *lunchIdentifier;
@property (strong, nonatomic, readonly) NSString *lunchDescription;
@property (strong, nonatomic, readonly) NSString *subtitle;
@property (strong, nonatomic, readonly) NSNumber *price;
@property (strong, nonatomic, readonly) NSURL *imgURL;


- (instancetype)initWithName:(NSString *)name
                  identifier:(NSNumber *)identifier
                    subtitle:(NSString *)subtitle
                       descr:(NSString *)descr
                       price:(NSNumber *)price
                      imgURL:(NSURL *)imgUrl;
@end
