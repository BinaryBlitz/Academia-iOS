//
//  ZPPUserManager.m
//  ZP
//
//  Created by Andrey Mikhaylov on 19/10/15.
//  Copyright © 2015 BinaryBlitz. All rights reserved.
//

#import "ZPPUserManager.h"
#import <Crashlytics/Crashlytics.h>
#import <CocoaLumberjack.h>
#import "ZPPServerManager+ZPPRegistration.h"

//static const int ddLogLevel = DDLogLevelDebug;

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
        _user = user;

        //[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];

        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:user];

        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"currentUser"];

        [[Crashlytics sharedInstance]
            setUserIdentifier:[NSString stringWithFormat:@"%@", user.userID]];
        [[Crashlytics sharedInstance] setUserName:user.firstName];
        if (user.email) {
            [[Crashlytics sharedInstance] setUserEmail:user.email];
        }

        if (self.pushToken) {
            //            [[QZBServerManager sharedManager] POSTAPNsToken:self.pushToken
            //                                                  onSuccess:^{
            //
            //                                                  }
            //                                                  onFailure:^(NSError *error,
            //                                                  NSInteger statusCode){
            //
            //                                                  }];
        }
    }
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
            onFailure:^(NSError *error, NSInteger statusCode){

            }];

    } else {
        
        return;
    }



    [[NSUserDefaults standardUserDefaults] setObject:pushToken forKey:@"APNStoken"];
    // [[NSUserDefaults standardUserDefaults] setObject:pushTokenData forKey:@"APNStokenData"];
    [[NSUserDefaults standardUserDefaults] synchronize];  //?

    DDLogVerbose(@"push token setted %@", self.pushToken);
}

- (void)userLogOut {
    // self.user.api_key = nil;

    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"APNStoken"];

    if (self.pushToken) {
        
        [[ZPPServerManager sharedManager] updateToken:[NSNull null] onSuccess:^{
            self.pushToken = nil;
        } onFailure:^(NSError *error, NSInteger statusCode) {
            
        }];
        
        //        [[QZBServerManager sharedManager] DELETEAPNsToken:self.pushToken
        //                                                onSuccess:^{ }
        //                                                onFailure:^(NSError *error, NSInteger
        //                                                statusCode){ }];
    }

    // [[QZBLayerMessagerManager sharedInstance] logOut];

    //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"APNStoken"];
    // self.pushToken = nil;
    self.user = nil;

    //[[NSUserDefaults standardUserDefaults] setBool:NO forKey:QZBNeedStartMessager];
    //  [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"currentUser"];
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
