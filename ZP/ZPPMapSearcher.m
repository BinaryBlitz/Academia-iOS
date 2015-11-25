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

static NSString *ZPPDaDataID = @"bfdacc45560db9c73425f30f5c630842e5c8c1ad";

@interface ZPPMapSearcher ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *manager;

@end

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

    [self searcDaDataWithAddress:addresString count:@(10) onSuccess:success onFailure:failure];
}

- (void)searchInForsquareWithAddress:(NSString *)addresString
                           onSuccess:(void (^)(NSArray *addresses))success
                           onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    AFHTTPRequestOperationManager *manager =
        self.manager;  //[AFHTTPRequestOperationManager manager];
    NSString *string = [NSString stringWithFormat:@"https://api.foursquare.com/v2/venues/search"];

    //   NSString *correctString = [addresString
    //   stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
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
            if (success) {
                success(addrs);
            }

        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

            NSLog(@"failure %@", error);

            if (failure) {
                failure(error, operation.response.statusCode);
            }
        }];
}

- (void)searcDaDataWithAddress:(NSString *)addresString
                         count:(NSNumber *)count
                     onSuccess:(void (^)(NSArray *addresses))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    //    AFHTTPRequestOperationManager *manager =
    //        self.manager;  //[AFHTTPRequestOperationManager manager];
    //    NSString *string = [NSString
    //    stringWithFormat:@"https://dadata.ru/api/v2/suggest/address"];
    //
    //    NSDictionary *params = @{ @"query" : addresString};
    //
    //    // AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    //
    //    //  [manager.requestSerializer setValue:@"SomeValue" forHTTPHeaderField:@"Content-Type"]
    //
    //    NSString *tokenString = [NSString stringWithFormat:@"Token %@", ZPPDaDataID];
    //    [manager.requestSerializer setValue:tokenString forHTTPHeaderField:@"Authorization"];
    //    [manager.requestSerializer setValue:@"application/json"
    //    forHTTPHeaderField:@"Content-Type"];
    //    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    //
    //        [manager POST:string parameters:params
    //        constructingBodyWithBlock:^(id<AFMultipartFormData>
    //        _Nonnull formData) {
    //
    ////            NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:params];
    ////            [formData appendPartWithHeaders:nil body:myData];
    //
    //        } success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject)
    //        {
    //             NSLog(@"%@", responseObject);
    //        } failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
    //            NSLog(@"%@", error);
    //        }];

    //    [manager POST:string
    //        parameters:params
    //        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
    //            NSLog(@"%@", responseObject);
    //        }
    //        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
    //            NSLog(@"%@", error);
    //        }];

    NSString *string = [NSString stringWithFormat:@"https://dadata.ru/api/v2/suggest/address"];
    NSURL *URL = [NSURL URLWithString:string];
    NSMutableURLRequest *request =
        [NSMutableURLRequest requestWithURL:URL
                                cachePolicy:NSURLRequestReloadIgnoringCacheData
                            timeoutInterval:10];

    //    NSDictionary *params = @{ @"query" : addresString };
    //    NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:params];
    NSString *tokenString = [NSString stringWithFormat:@"Token %@", ZPPDaDataID];
    [request setHTTPMethod:@"POST"];
    [request setValue:tokenString forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    NSString *bodyStr = [NSString
//        stringWithFormat:@"{\"query\":\"%@\", \"locations\": [{ \"region\": \"москва\" }]}",
//                         addresString];

    NSDictionary *params = @{
        @"query" : addresString,
        @"count" : count,
        @"locations" : @[ @{@"region" : @"москва"} ]
    };
    
    NSString *paramsString = [self bv_jsonStringWithPrettyPrint:YES dict:params];

    [request setHTTPBody:[paramsString dataUsingEncoding:NSUTF8StringEncoding]];

    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {

        NSLog(@"JSON responseObject: %@ ", responseObject);

        NSArray *suggestions = responseObject[@"suggestions"];
        NSArray *addresses = [ZPPAddressHelper addressesFromDaDataDicts:suggestions];

        if (success) {
            success(addresses);
        }

        //   NSLog(@"JSON responseObject: %@ ", responseObject);

    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", [error localizedDescription]);

        if (failure) {
            failure(error, operation.response.statusCode);
        }

    }];
    [op start];
}

- (NSString *)bv_jsonStringWithPrettyPrint:(BOOL)prettyPrint dict:(NSDictionary *)dict {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization
        dataWithJSONObject:dict
                   options:(NSJSONWritingOptions)(prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                     error:&error];

    if (!jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
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
        self.manager = [[AFHTTPRequestOperationManager alloc] init];
        // [self propertiesInitializing];
    }
    return self;
}

@end
