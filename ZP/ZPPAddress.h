@import Foundation;
@import MapKit;

@interface ZPPAddress : NSObject

@property (assign, nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (strong, nonatomic, readonly) NSString *country;
@property (strong, nonatomic, readonly) NSString *city;
@property (strong, nonatomic, readonly) NSString *address;

- (instancetype)initWithCoordinate:(CLLocationCoordinate2D)coordinate
                           Country:(NSString *)country
                              city:(NSString *)city
                           address:(NSString *)address;

- (NSString *)formattedDescription;

@end
