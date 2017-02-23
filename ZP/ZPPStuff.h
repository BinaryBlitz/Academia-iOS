#import <Foundation/Foundation.h>
#import "ZPPItemProtocol.h"
#import "ZPPWithImageURL.h"

@interface ZPPStuff : NSObject <ZPPItemProtocol, ZPPWithImageURL>

@property (strong, nonatomic, readonly) NSString *name;
@property (strong, nonatomic, readonly) NSNumber *price;
@property (strong, nonatomic, readonly) NSString *stuffDescr;
@property (strong, nonatomic, readonly) NSURL *imgURl;

- (instancetype)initWithName:(NSString *)name
                  identifier:(NSNumber *)identifier
                       descr:(NSString *)descr
                       price:(NSNumber *)price
                      imgURL:(NSURL *)imgURL;
@end
