//
//  ZPPCardNumberTextField.m
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPCardNumberTextField.h"

@implementation ZPPCardNumberTextField

- (CGRect)textRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}

// text position
- (CGRect)editingRectForBounds:(CGRect)bounds {
    return CGRectInset(bounds, 10, 10);
}


@end
