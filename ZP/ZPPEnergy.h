#import <Foundation/Foundation.h>

@interface ZPPEnergy : NSObject

@property (strong, nonatomic, readonly) NSNumber *fats;
@property (strong, nonatomic, readonly) NSNumber *kilocalories;
@property (strong, nonatomic, readonly) NSNumber *carbohydrates;
@property (strong, nonatomic, readonly) NSNumber *proteins;

- (instancetype)initWithFats:(NSNumber *)fats
                kilocalories:(NSNumber *)kilocalories
               carbohydrates:(NSNumber *)carbohydrates
                    proteins:(NSNumber *)proteins;


@end
