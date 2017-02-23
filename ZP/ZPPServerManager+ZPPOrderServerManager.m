//
//  ZPPServerManager+ZPPOrderServerManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 14/11/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPServerManager+ZPPOrderServerManager.h"

@import AFNetworking;
#import "ZPPUserManager.h"
#import "ZPPOrder.h"
#import "ZPPOrderHelper.h"
#import "ZPPAddressHelper.h"
#import "ZPPTimeManager.h"
#import "ZPPCreditCard.h"

@implementation ZPPServerManager (ZPPOrderServerManager)

- (void)GETOldOrdersOnSuccess:(void (^)(NSArray *orders))success
                    onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *params = @{@"api_token": [ZPPUserManager sharedInstance].user.apiToken};
  [self.requestOperationManager GET:@"orders.json"
                         parameters:params
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                              NSLog(@"old dicts %@", responseObject);

                              NSArray *orders = [ZPPOrderHelper parseOrdersFromDicts:responseObject];

                              if (success) {
                                success(orders);
                              }
                            }
                            failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

                              [[self class] failureWithBlock:failure error:error operation:operation];
                            }];
}

- (void)POSTOrder:(ZPPOrder *)order
        onSuccess:(void (^)(ZPPOrder *order))success
        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *orderDict = [ZPPOrderHelper orderDictFromOrder:order];

  NSDictionary *params =
      @{@"order": orderDict,
          @"api_token": [ZPPUserManager sharedInstance].user.apiToken};

  [self.requestOperationManager POST:@"orders.json"
                          parameters:params
                             success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
                               NSLog(@"post order %@", responseObject);

                               ZPPOrder *o = [ZPPOrderHelper parseOrderFromDict:responseObject];
                               if (success) {
                                 success(o);
                               }
                             }
                             failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
                               [[self class] failureWithBlock:failure error:error operation:operation];
                             }];
}

- (void)POSTPaymentWithOrderID:(NSString *)orderID
                     onSuccess:(void (^)(NSString *paymnetURL))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure
__attribute__((deprecated("use createNewPaymentWithOrderId instead"))) {
  NSDictionary *params = @{
      @"api_token": [ZPPUserManager sharedInstance].user.apiToken,
      @"payment": @{@"use_binding": @NO}
  };

  NSString *urlString = [NSString stringWithFormat:@"orders/%@/payment.json", orderID];

  [self.requestOperationManager POST:urlString
                          parameters:params
                             success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                               NSLog(@"payment resp %@", responseObject);
                               NSString *url = responseObject[@"url"];
                               if (success) {
                                 success(url);
                               }
                             }
                             failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

                               if (failure) {
                                 [[self class] failureWithBlock:failure error:error operation:operation];
                               }
                             }];
}

- (void)checkPaymentWithID:(NSString *)orderID
                 onSuccess:(void (^)(NSInteger sta))success
                 onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *params = @{@"api_token": [ZPPUserManager sharedInstance].user.apiToken};

  NSString *urlString = [NSString stringWithFormat:@"orders/%@/payment_status", orderID];

  [self.requestOperationManager GET:urlString
                         parameters:params
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                              NSLog(@"payment status response %@", responseObject);

                              //order status 2 is good
                              NSNumber *orederStatus = responseObject[@"order_status"];

                              if (success) {
                                NSInteger status = [orederStatus integerValue];
                                if (status) {
                                  success([orederStatus integerValue]);
                                } else {
                                  failure(nil, 418);
                                }
                              }
                            }
                            failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
                              [[self class] failureWithBlock:failure error:error operation:operation];
                            }];
}

#pragma mark - Credit cards

- (void)createNewPaymentWithOrderId:(NSString *)orderId andBindingId:(NSString *)bindingId
                          onSuccess:(void (^)(NSString *paymentURLString))success
                          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *parameters = @{
      @"api_token": [ZPPUserManager sharedInstance].user.apiToken,
      @"payment": @{@"binding_id": bindingId}
  };

  NSString *urlString = [NSString stringWithFormat:@"orders/%@/payments", orderId];

  [self.requestOperationManager POST:urlString
                          parameters:parameters
                             success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                               NSLog(@"payment response: %@", (NSDictionary *) responseObject);
                               NSString *url = responseObject[@"redirect"];
                               if (success) {
                                 success(url);
                               }
                             }
                             failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

                               if (failure) {
                                 [[self class] failureWithBlock:failure error:error operation:operation];
                               }
                             }];
}

- (void)listPaymentCardsWithSuccess:(void (^)(NSArray *cards))success
                          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *parameters = @{@"api_token": [ZPPUserManager sharedInstance].user.apiToken};

  [self.requestOperationManager GET:@"payment_cards"
                         parameters:parameters
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                              if (responseObject) {
                                NSLog(@"cards: %@", responseObject);
                                NSMutableArray *cards = [NSMutableArray array];
                                for (NSDictionary *cardData in responseObject) {
                                  ZPPCreditCard *card = [ZPPCreditCard initWithDictionary:cardData];
                                  if (card) {
                                    [cards addObject:card];
                                  }
                                }

                                [cards sortUsingComparator:^NSComparisonResult(id _Nonnull obj1, id _Nonnull obj2) {
                                  ZPPCreditCard *firstCard = (ZPPCreditCard *) obj1;
                                  ZPPCreditCard *secondCard = (ZPPCreditCard *) obj2;
                                  return [firstCard.createdAt compare:secondCard.createdAt];
                                }];

                                success([NSArray arrayWithArray:cards]);
                              }
                            } failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
        [[self class] failureWithBlock:failure error:error operation:operation];
      }];
}

- (void)registerNewCreditCardOnSuccess:(void (^)(NSString *registrationURLString))success
                             onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *parameters = @{
      @"api_token": [ZPPUserManager sharedInstance].user.apiToken
  };

  [self.requestOperationManager POST:@"payment_cards"
                          parameters:parameters
                             success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
                               NSString *error = responseObject[@"error"];
                               if (error) {
                                 NSLog(@"Error: %@", error);
                                 [[self class] failureWithBlock:failure error:error operation:operation];
                               }

                               NSString *url = responseObject[@"url"];
                               if (success) {
                                 success(url);
                               }
                             }
                             failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

                               if (failure) {
                                 [[self class] failureWithBlock:failure error:error operation:operation];
                               }
                             }];
}

- (void)processPaymentURLString:(NSString *)paymentURL onSuccess:(void (^)(NSString *redirectURLString))success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSURL *url = [NSURL URLWithString:paymentURL];
  NSURLRequest *request = [NSURLRequest requestWithURL:url];
  AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]
      initWithRequest:request];

  [operation setCompletionBlockWithSuccess:
      ^(AFHTTPRequestOperation *operation, id responseObject) {
      }                            failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    if (failure) {
      [[self class] failureWithBlock:failure error:error operation:operation];
    }
  }
  ];

  [operation setRedirectResponseBlock:^NSURLRequest * _Nonnull (NSURLConnection *
  _Nonnull connection, NSURLRequest *_Nonnull request, NSURLResponse
  *
  _Nonnull redirectResponse) {

    if ([request.URL.absoluteString containsString:@"sakses"] || [request.URL.absoluteString containsString:@"feylur"]) {
      dispatch_async(dispatch_get_main_queue(), ^{
        success(request.URL.absoluteString);
      });
    }

    return request;
  }];

  [operation start];
}

#pragma mark - Time stuff

- (void)getWorkingHours:(void (^)(ZPPTimeManager *timeManager))success
              onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *parameters = @{@"api_token": [ZPPUserManager sharedInstance].user.apiToken};
  NSString *urlString = @"working_hours";

  [self.requestOperationManager GET:urlString
                         parameters:parameters
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
                              ZPPTimeManager *timeManager = [ZPPTimeManager timeManagerWith:responseObject];
                              if (success) {
                                success(timeManager);
                              }
                            } failure:^(AFHTTPRequestOperation *_Nullable operation, NSError *_Nonnull error) {
        [[self class] failureWithBlock:failure error:error operation:operation];
      }];
}

#pragma mark - Review

- (void)sendComment:(NSString *)comment
     forOrderWithID:(NSString *)orderID
          onSuccess:(void (^)())success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {

  NSDictionary *params = @{
      @"api_token": [ZPPUserManager sharedInstance].user.apiToken,
      @"order": @{@"review": comment}
  };

  NSString *urlString = [NSString stringWithFormat:@"orders/%@", orderID];

  [self.requestOperationManager PATCH:urlString
                           parameters:params
                              success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                                if (success) {
                                  success();
                                }
                              }
                              failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

                                [[self class] failureWithBlock:failure error:error operation:operation];
                              }];
}

- (void)patchStarsWithValue:(NSNumber *)starValue
             forOrderWithID:(NSString *)orderID
                  onSuccess:(void (^)())success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *params = @{
      @"api_token": [ZPPUserManager sharedInstance].user.apiToken,
      @"order": @{@"rating": starValue}
  };

  NSString *urlString = [NSString stringWithFormat:@"orders/%@", orderID];

  [self.requestOperationManager PATCH:urlString
                           parameters:params
                              success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                                if (success) {
                                  success();
                                }
                              }
                              failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

                                [[self class] failureWithBlock:failure error:error operation:operation];
                              }];
}

#pragma mark - Geo

- (void)getPoligonPointsOnSuccess:(void (^)(NSArray *points))success
                        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  NSDictionary *params = @{@"api_token": [ZPPUserManager sharedInstance].user.apiToken};

  [self.requestOperationManager GET:@"edge_points.json"
                         parameters:params
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                              NSLog(@"points %@", responseObject);

                              NSArray *points = [ZPPAddressHelper parsePoints:responseObject];

                              if (success) {
                                success(points);
                              }
                            }
                            failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {

                              [[self class] failureWithBlock:failure error:error operation:operation];
                            }];
}

@end
