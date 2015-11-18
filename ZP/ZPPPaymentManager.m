//
//  ZPPPaymentManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 16/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPPaymentManager.h"
#import <AFNetworking.h>
#import "ZPPUserManager.h"
#import "ZPPCreditCard.h"

#import "ZPPOrder.h"

NSString *const ZPPPaymnetBaseURL = @"https://test.paymentgate.ru";
NSString *const ZPPPaymentFinishURL = @"finish.html";
NSString *const ZPPCentralURL = @"merchants/zdorovoepitanie";

@interface ZPPPaymentManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (copy, nonatomic) NSString *baseURL;

@end

@implementation ZPPPaymentManager

+ (ZPPPaymentManager *)sharedManager {
    static ZPPPaymentManager *manager = nil;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[ZPPPaymentManager alloc] init];
    });

    return manager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *apiPath =
            [NSString stringWithFormat:@"%@/%@", ZPPPaymnetBaseURL, @"testpayment"];  //, @"api"];
        self.baseURL = apiPath;

        NSURL *url = [NSURL URLWithString:apiPath];

        self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];

        // self.requestOperationManager.responseSerializer = [AFHTTPResponseSerializer serializer];

        self.requestOperationManager.responseSerializer.acceptableContentTypes = nil;
    }
    return self;
}

// userName=zdorovoepitanie-api&
// password=zdorovoepitanie&
// amount=100&
// currency=810&
// language=ru&
// description=две мясных котлеты гриль, специальный соус, сыр/оугрцы, салат и лук&
// orderNumber=test6&
// clientId=1&
// returnUrl=finish.html

// redo

- (void)registrateOrder:(ZPPOrder *)order
              onSuccess:(void (^)(NSURL *url, NSString *orderIDAlfa))success
              onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    if (!order.identifier) {
        if (failure) {
            failure(nil, -1);
        }
        return;
    }

    NSString *userID = [ZPPUserManager sharedInstance].user.userID;

    NSNumber *totalPrice = @(100 * [order totalPrice]);

    NSDictionary *params;
    if (order.card.bindID) {
        params = @{
            @"userName" : @"zdorovoepitanie_auto-api",
            @"password" : @"zdorovoepitanie",
            @"amount" : totalPrice,
            @"currency" : @"810",
            @"language" : @"ru",
            @"description" : [order description],
            @"orderNumber" : order.identifier,
            @"clientId" : userID,
            @"bindingId" : order.card.bindID,
            @"returnUrl" : ZPPPaymentFinishURL
        };
    } else {
        params = @{
            @"userName" : @"zdorovoepitanie-api",
            @"password" : @"zdorovoepitanie",
            @"amount" : totalPrice,
            @"currency" : @"810",
            @"language" : @"ru",
            @"description" : [order orderDescr],
            @"orderNumber" : order.identifier,
            @"clientId" : userID,
            @"returnUrl" : ZPPPaymentFinishURL
        };
    }
    
    [self registerWith:params onSuccess:success onFailure:failure];
}

- (void)registrateWithOrderNum:(NSString *)orderNumber
                     onSuccess:(void (^)(NSURL *url, NSString *orderIDAlfa))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSInteger testNum = arc4random() % 100;
    NSString *orderNumAsString = [NSString stringWithFormat:@"zp%@", @(testNum)];

    NSString *userID = [ZPPUserManager sharedInstance].user.userID;

    NSDictionary *params = @{
        @"userName" : @"zdorovoepitanie-api",
        @"password" : @"zdorovoepitanie",
        @"amount" : @"100",
        @"currency" : @"810",
        @"language" : @"ru",
        @"description" : @"description",
        @"orderNumber" : orderNumAsString,
        @"clientId" : userID,
        @"returnUrl" : ZPPPaymentFinishURL
    };

    [self registerWith:params onSuccess:success onFailure:failure];

    //    [self.requestOperationManager POST:@"rest/register.do"
    //        parameters:params
    //        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
    //            NSLog(@"resp %@", responseObject);
    //            NSString *urlAsString = responseObject[@"formUrl"];
    //
    //            if (!orderNumAsString || [orderNumAsString isEqual:[NSNull null]]) {
    //                if (failure) {
    //                    failure(nil, -5);
    //                }
    //                return;
    //            }
    //
    //            NSString *ordID = responseObject[@"orderId"];
    //            NSURL *destURL = [NSURL URLWithString:urlAsString];
    //
    //            if (success) {
    //                success(destURL, ordID);
    //            }
    //        }
    //        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
    //            NSLog(@"err resp %@ \n err %@", operation.responseObject, error);
    //            if (failure) {
    //                failure(error, operation.response.statusCode);
    //            }
    //        }];
}

// userName=zdorovoepitanie-api&
// password=zdorovoepitanie&
// orderId=25356dda-763f-4c43-b9f8-406de9111075

- (void)getOrderStatus:(NSString *)orderId
             onSuccess:(void (^)(NSString *bindingID))success
             onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSDictionary *params = @{
        @"userName" : @"zdorovoepitanie-api",
        @"password" : @"zdorovoepitanie",
        @"orderId" : orderId,
        @"language" : @"ru"

    };

    [self.requestOperationManager GET:@"rest/getOrderStatus.do"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSLog(@"ord resp %@", responseObject);
            NSString *bindID = responseObject[@"bindingId"];
            if (success) {
                success(bindID);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSLog(@"err resp %@ \n err %@", operation.responseObject, error);
            if (failure) {
                failure(error, operation.response.statusCode);
            }
        }];
}

// userName=zdorovoepitanie_auto-api&
// password=zdorovoepitanie&
// amount=20000&
// currency=810&
// language=ru&
// description=drPepper&
// orderNumber=stest1&
// clientId=1&
// bindingId=402d2cac-dc16-4af9-ac19-00605ff9b012&
// returnUrl=finish.html

- (void)postOrderWithBindingID:(NSString *)bindingId
                          cost:(NSInteger)cost
                         descr:(NSString *)descr
                     onSuccess:(void (^)(NSURL *url, NSString *orderIDAlfa))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    NSInteger testNum = 100 + arc4random() % 100;
    NSString *orderNumAsString = [NSString stringWithFormat:@"zp%@", @(testNum)];

    NSString *userID = [ZPPUserManager sharedInstance].user.userID;

    NSNumber *totalPrice = @(100 * cost);

    NSDictionary *params = @{
        @"userName" : @"zdorovoepitanie_auto-api",
        @"password" : @"zdorovoepitanie",
        @"amount" : totalPrice,
        @"currency" : @"810",
        @"language" : @"ru",
        @"description" : descr,
        @"orderNumber" : orderNumAsString,
        @"clientId" : userID,
        @"bindingId" : bindingId,
        @"returnUrl" : ZPPPaymentFinishURL
    };

    [self registerWith:params onSuccess:success onFailure:failure];
}

- (void)registerWith:(NSDictionary *)params
           onSuccess:(void (^)(NSURL *url, NSString *orderIDAlfa))success
           onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
    [self.requestOperationManager POST:@"rest/register.do"
        parameters:params
        success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
            NSLog(@"resp %@", responseObject);
            NSString *urlAsString = responseObject[@"formUrl"];

            if (!urlAsString || [urlAsString isEqual:[NSNull null]]) {
                if (failure) {
                    failure(nil, -5);
                }
                return;
            }

            NSString *ordID = responseObject[@"orderId"];
            NSURL *destURL = [NSURL URLWithString:urlAsString];

            if (success) {
                success(destURL, ordID);
            }
        }
        failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
            NSLog(@"err resp %@ \n err %@", operation.responseObject, error);
            if (failure) {
                failure(error, operation.response.statusCode);
            }
        }];
}




@end
