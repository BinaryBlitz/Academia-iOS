//
//  ZPPCreditCard.h
//  ZP
//
//  Created by Andrey Mikhaylov on 09/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZPPCreditCard : NSObject

@property (strong, nonatomic, readonly) NSString *cardNumber;
@property (assign, nonatomic, readonly) NSInteger month;
@property (assign, nonatomic, readonly) NSInteger year;
@property (strong, nonatomic, readonly) NSString *bindID;

- (instancetype)initWithCardNumber:(NSString *)cardNumber
                             month:(NSInteger)month
                              year:(NSInteger)year
                               cvc:(NSInteger)cvc;

- (instancetype)initWithCardNumber:(NSString *)cardNumber
                             month:(NSInteger)month
                              year:(NSInteger)year
                            bindID:(NSString *)bindID;



- (NSString *)formattedDate;




@end
