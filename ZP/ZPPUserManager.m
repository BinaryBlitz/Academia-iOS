
#import <Crashlytics/Crashlytics.h>
#import "ZPPServerManager+ZPPRegistration.h"
#import "ZPPUserManager.h"

// static const int ddLogLevel = DDLogLevelDebug;

NSString *const ZPPUserLogoutNotificationName = @"ZPPUserLogoutNotificationName";
NSString *const ZPPUserLoginNotificationName = @"ZPPUserLoginNotificationName";

@interface ZPPUserManager ()

@property (strong, nonatomic) ZPPUser *user;
@property (strong, nonatomic) NSString *pushToken;
@property (strong, nonatomic) NSData *pushTokenData;

@end

@implementation ZPPUserManager

+ (instancetype)sharedInstance {
  static ZPPUserManager *sharedInstance = nil;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedInstance = [[ZPPUserManager alloc] init];
  });
  return sharedInstance;
}

- (instancetype)init {
  self = [super init];
  if (self) {
    // self.pushToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"APNStoken"];
  }
  return self;
}

- (void)setUser:(ZPPUser *)user {

  if (user) {
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];

    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentUser"];

    [[Crashlytics sharedInstance]
        setUserIdentifier:[NSString stringWithFormat:@"%@", user.userID]];
    [[Crashlytics sharedInstance] setUserName:user.firstName];
    if (user.email) {
      [[Crashlytics sharedInstance] setUserEmail:user.email];
    }

    if (self.pushToken) {
    }
    if (!_user && user) {
      [[NSNotificationCenter defaultCenter] postNotificationName:ZPPUserLoginNotificationName object:nil];
    }
  } else {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
    [[NSNotificationCenter defaultCenter] postNotificationName:ZPPUserLogoutNotificationName
                                                        object:nil];
  }
  _user = user;
}

- (void)setAPNsToken:(NSData *)pushTokenData {
  //    self.pushTokenData = pushTokenData;
  NSString *pushToken = [pushTokenData description];
  pushToken = [pushToken
      stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
  pushToken = [pushToken stringByReplacingOccurrencesOfString:@" " withString:@""];

  self.pushToken = pushToken;
  if (self.user) {
    [[ZPPServerManager sharedManager] updateToken:pushToken
                                        onSuccess:^{
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                        }];
  } else {
    return;
  }

  [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:@"APNStoken"];
  // [[NSUserDefaults standardUserDefaults] setObject:pushTokenData forKey:@"APNStokenData"];
  [[NSUserDefaults standardUserDefaults] synchronize];  //?

//    DDLogVerbose(@"push token setted %@", self.pushToken);
}

- (void)userLogOut {
  if (self.pushToken) {
    [[ZPPServerManager sharedManager] updateToken:nil
                                        onSuccess:^{
                                          self.pushToken = nil;
                                        }
                                        onFailure:^(NSError *error, NSInteger statusCode) {
                                        }];
  }

  self.user = nil;
}

- (BOOL)checkUser {
  if ([[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"]) {
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUser"];
    self.user = [NSKeyedUnarchiver unarchiveObjectWithData:data];

    //  [self.user updateUserFromServer];

    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"APNStoken"]) {
      self.pushToken = [[NSUserDefaults standardUserDefaults] objectForKey:@"APNStoken"];
    }

    return YES;
  } else {
    if ([[NSUserDefaults standardUserDefaults] objectForKey:@"APNStoken"]) {
      //если нет пользователя, но есть токен. Токен необходимо удалить с сервера.
    }

    return NO;
  }
}

- (void)updateUser {
  // TODO
}

@end
