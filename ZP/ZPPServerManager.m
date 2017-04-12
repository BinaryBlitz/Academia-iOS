#import "ZPPServerManager.h"

@import AFNetworking;

NSString *const ZPPServerBaseUrl = @"https://academia-delivery.herokuapp.com";

NSString *const ZPPNoInternetConnectionMessage = @"Проверьте интернет соединение";

@interface ZPPServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager *requestOperationManager;
@property (copy, nonatomic) NSString *baseURL;

@end

@implementation ZPPServerManager

+ (ZPPServerManager *)sharedManager {
  static ZPPServerManager *manager = nil;

  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    manager = [[ZPPServerManager alloc] init];
  });

  return manager;
}

- (id)init {
  self = [super init];
  if (self) {
    NSString *apiPath = [NSString stringWithFormat:@"%@", ZPPServerBaseUrl];
    self.baseURL = apiPath;
    NSURL *url = [NSURL URLWithString:apiPath];

    self.requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
  }
  return self;
}

#pragma mark - support

+ (void)failureWithBlock:(failureBlock)block
                   error:(NSError *)error
               operation:(AFHTTPRequestOperation *)operation {
  if (block) {
    block(error, operation.response.statusCode);
  }
}

@end
