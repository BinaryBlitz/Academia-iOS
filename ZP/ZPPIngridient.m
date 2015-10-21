//
//  ZPPIngridient.m
//  ZP
//
//  Created by Andrey Mikhaylov on 20/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPIngridient.h"

@interface ZPPIngridient()
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *ingridientID;
@property (copy, nonatomic) NSString *urlAsString;

@end

@implementation ZPPIngridient

//"id": 9,
//"name": "Nectarine",
//"image_url": "/uploads/ingredient/image/9/f9db06715841dcb5da49864c4f744edb.jpg"

- (instancetype)initWithName:(NSString *)name
                ingridientID:(NSString *)ingridientID
                 urlAsString:(NSString *)urlAsString {
    self = [super init];
    if (self) {
        self.name = name;
        self.ingridientID = ingridientID;
        self.urlAsString = urlAsString;
    }
    return self;
}

@end
