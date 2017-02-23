#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"

@interface ZPPGift : NSObject <ZPPItemProtocol>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSString *giftDescription;
@property (strong, nonatomic, readonly) NSNumber *price;

- (instancetype)initWith:(NSString *)name
             description:(NSString *)giftDescription
                   price:(NSNumber *)price
              identifier:(NSNumber *)giftIdentifier;

//- (NSInteger)priceOfItem;
//- (NSString *)nameOfItem;

@end
