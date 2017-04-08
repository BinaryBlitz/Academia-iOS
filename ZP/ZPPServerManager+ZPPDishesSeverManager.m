#import "ZPPServerManager+ZPPDishesSeverManager.h"
#import "AFNetworking.h"
#import "ZPPUserManager.h"
#import "ZPPDishHelper.h"
#import "ZPPCategoryHelper.h"
#import "ZPPStuffHelper.h"
#import "ZPPTimeManager.h"
#import "Academia-Swift.h"
#import "ZPPCategory.h"

@implementation ZPPServerManager (ZPPDishesSeverManager)

- (void)getCategoriesOnSuccess:(void (^)(NSArray *))success onFailure:(void (^)(NSError *, NSInteger))failure {
  ZPPUser *user = [ZPPUserManager sharedInstance].user;
  NSMutableDictionary *params = [NSMutableDictionary new];
  if (user.apiToken) {
    [params setValue:user.apiToken forKey:@"api_token"];
  }

  [self.requestOperationManager GET:@"categories.json"
                         parameters:params
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {

                              NSArray *categories = [ZPPCategoryHelper parseCategories:responseObject];

                              if (success) {
                                success(categories);
                              }
                            }
                            failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
                              [[self class] failureWithBlock:failure error:error operation:operation];
                            }];

}

- (void)getDishesWithCategory:(ZPPCategory *) category
                    onSuccess:(void (^)(NSArray *dishes)) success
                    onFailure:(void (^)(NSError *error, NSInteger statusCode)) failure {
  ZPPUser *user = [ZPPUserManager sharedInstance].user;
  NSMutableDictionary *params = [NSMutableDictionary new];
  if (user.apiToken) {
    [params setValue:user.apiToken forKey:@"api_token"];
  }

  [self.requestOperationManager GET:[NSString stringWithFormat:@"categories/%@/dishes.json", category._id]
                         parameters:params
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
                              if (category.complementary) {
                                NSArray *dishes = [ZPPStuffHelper parseStuff:responseObject];
                                if (success) {
                                  success(dishes);
                                }
                              } else {
                                NSArray *dishes = [ZPPDishHelper parseDishes:responseObject];
                                if (success) {
                                  success(dishes);
                                }
                              }
                            }
                            failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
                              [[self class] failureWithBlock:failure error:error operation:operation];
                            }];
}

- (void)getDayMenu {

  ZPPUser *user = [ZPPUserManager sharedInstance].user;
  NSString *token = user.apiToken;
  NSDictionary *params;
  if (token) {
    params = @{@"api_token": [ZPPUserManager sharedInstance].user.apiToken};
  }

  [self.requestOperationManager GET:@"day.json"
                         parameters:params
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
                              NSLog(@"%@", responseObject);
                              [[ZPPTimeManager sharedManager] configureWithDict:responseObject];
                            } failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
        [[self class] failureWithBlock:nil error:error operation:operation];
      }];

}

- (void)GETCategoriesOnSuccesOnSuccess:(void (^)(NSArray *categories))success
                         onFailure:(void (^)(NSError *error, NSInteger statusCode))failure {
  ZPPUser *user = [ZPPUserManager sharedInstance].user;
  NSString *token = user.apiToken;
  NSDictionary *params;
  if (token) {
    params = @{@"api_token": [ZPPUserManager sharedInstance].user.apiToken};
  }

  [self.requestOperationManager GET:@"categories.json"
                         parameters:params
                            success:^(AFHTTPRequestOperation *_Nonnull operation, id _Nonnull responseObject) {
                              NSLog(@"%@", responseObject);

                              NSMutableArray *categories = [NSMutableArray array];

                              for(NSDictionary* categoryDict in (NSArray *)responseObject) {
                                NSNumber *identificator = 0;
                                NSString *name = @"";
                                BOOL complementary = NO;

                                if (categoryDict[@"id"]) {
                                  identificator = categoryDict[@"id"];
                                }
                                if (categoryDict[@"name"]) {
                                  identificator = categoryDict[@"name"];
                                }

                                if (categoryDict[@"complementary"]) {
                                  complementary = categoryDict[@"complementary"];
                                }

                                ZPPCategory* category = [[ZPPCategory alloc] initWithIdentificator:identificator name:name complementary:complementary];
                                [categories addObject:category];
                              }

                              if (success) {
                                success([NSArray arrayWithArray:categories]);
                              }
                            } failure:^(AFHTTPRequestOperation *_Nonnull operation, NSError *_Nonnull error) {
                              [[self class] failureWithBlock:failure error:error operation:operation];
                            }];

}


@end
