#import "ZPPServerManager.h"

@class ZPPOrder;
@class ZPPTimeManager;

@interface ZPPServerManager (ZPPOrderServerManager)

- (void)GETOldOrdersOnSuccess:(void (^)(NSArray *orders))success
                    onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)POSTOrder:(ZPPOrder *)order
        onSuccess:(void (^)(ZPPOrder *order))success
        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)POSTPaymentWithOrderID:(NSString *)orderID
                     onSuccess:(void (^)(NSString *paymnetURL))success
                     onFailure:(void (^)(NSError *error, NSInteger statusCode))failure
__attribute__((deprecated("use createNewPaymentWithOrderId instead")));

- (void)checkPaymentWithID:(NSString *)orderID
                 onSuccess:(void (^)(NSInteger sta))success
                 onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)getWorkingHours:(void (^)(ZPPTimeManager *timeManager))success
              onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

#pragma mark - Credit cards

- (void)listPaymentCardsWithSuccess:(void (^)(NSArray *cards))success
                          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)createNewPaymentWithOrderId:(NSString *)orderId andBindingId:(NSString *)bindingId
                          onSuccess:(void (^)(NSString *paymentURLString))success
                          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)registerNewCreditCardOnSuccess:(void (^)(NSString *registrationURLString))success
                             onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)processPaymentURLString:(NSString *)paymentURL onSuccess:(void (^)(NSString *redirectURLString))success
                      onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

#pragma mark - Review

- (void)sendComment:(NSString *)comment
     forOrderWithID:(NSString *)orderID
          onSuccess:(void (^)())success
          onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

- (void)patchStarsWithValue:(NSNumber *)starValue
             forOrderWithID:(NSString *)orderID
                  onSuccess:(void (^)())success
                  onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

#pragma mark - Geo

- (void)getPoligonPointsOnSuccess:(void (^)(NSArray *points))success
                        onFailure:(void (^)(NSError *error, NSInteger statusCode))failure;

@end
