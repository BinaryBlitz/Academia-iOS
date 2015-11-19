//
//  ZPPConfigureWithOrder.h
//  ZP
//
//  Created by Andrey Mikhaylov on 19/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ZPPOrder;

@protocol ZPPConfigureWithOrder <NSObject>

- (void)configureWithOrder:(ZPPOrder *)order;

@end
