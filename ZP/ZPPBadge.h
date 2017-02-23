#import <Foundation/Foundation.h>
#import "ZPPWithImageURL.h"

@interface ZPPBadge : NSObject <ZPPWithImageURL>

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSURL *imgURL;
@property (strong, nonatomic) NSString *identifier;

- (instancetype)initWithName:(NSString *)name
                    imageURL:(NSURL *)imgURL
                  identifier:(NSString *)identifier;


@end
