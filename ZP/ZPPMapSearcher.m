//
//  ZPPMapSearcher.m
//  ZP
//
//  Created by Andrey Mikhaylov on 13/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPMapSearcher.h"
#import <AFNetworking.h>

#import "ZPPAddressHelper.h"

// https://api.foursquare.com/v2/venues/search/?v=%25s&locale=en&limit=25&client_id=%25s&client_secret=%25s&ll=%25s

// url = String.format(Locale.US,
//                    "https://api.foursquare.com/v2/venues/search/?v=%s&locale=en&limit=25&client_id=%s&client_secret=%s&ll=%s",
//                    "20130815", "34VOBYGUAUDEJWBQ4BUACK1U5VITMW2BLMDMNCYYWUJNYLB4",
//                    "DGYUVXJPWXSDGVTDJBY320WDE3QYRD5REUSG5CAAWVVS500U",
//                    String.format(Locale.US, "%f,%f", coordinate.latitude, coordinate.longitude));

static NSString *ZPPClientSecret = @"EPD0Y5G10BHTNEFFBYDNCUOKYJZSEWVYYZVIUB03CAEHGJFB";
static NSString *ZPPClientID = @"W2EIJVGKHTJMB5NGC21UV1AVRNJW4MUYKVLLG0MZV31N0IUQ";

@implementation ZPPMapSearcher

- (void)searchAddres:(NSString *)addresString
           onSuccess:(void (^)(NSArray *addresses))success
           onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    if (!addresString) {
        if (failure) {
            failure(nil, -1);
        }
        return;
    }

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSString *string = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search"];

 //   NSString *correctString = [addresString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    // redo locale
    
   // NSString *correctString = [[NSString alloc] initw
    NSDictionary *params = @{
        @"v" : @"20130815",
        @"locale" : @"ru",
        @"limit" : @"25",
        @"client_id" : ZPPClientID,
        @"client_secret" : ZPPClientSecret,
        @"near" : addresString

    };

    [manager GET:string
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

            NSLog(@"%@", responseObject);
            
//            NSDictionary *respDict = responseObject[@"response"];
//            
//            if(respDict && ![respDict isEqual:[NSNull null]]) {
//                NSArray *venues = respDict[@"venues"];
//                
//            }
            NSArray *addrs = [ZPPAddressHelper addressesFromFoursquareDict:responseObject];
            if(success) {
                success(addrs);
            }
            
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            NSLog(@"failure %@", error);
            
            if(failure) {
                failure(error, operation.response.statusCode);
            }
        }];
}

+ (instancetype)shared {
    static ZPPMapSearcher *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[ZPPMapSearcher alloc] init];
    });
    return sharedInstance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        // [self propertiesInitializing];
    }
    return self;
}

@end
