#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"

@interface ZPPOrderItem : NSObject

@property (strong, nonatomic, readonly) id <ZPPItemProtocol> item;
@property (assign, nonatomic, readonly) NSInteger count;

- (instancetype)initWithItem:(id <ZPPItemProtocol>)item count:(NSInteger)count;
- (instancetype)initWithItem:(id <ZPPItemProtocol>)item;
- (void)addOneItem;
- (void)removeOneItem;

- (NSInteger)totalPrice;

@end
