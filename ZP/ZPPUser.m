//
//  QZBUser.m
//  QZBQuizBattle
//
//  Created by Andrey Mikhaylov on 13/12/14.
//  Copyright (c) 2014 Andrey Mikhaylov. All rights reserved.
//

#import "ZPPUser.h"
#import "ZPPUserHelper.h"


//static NSString *ZPPFirstName = @"first_name";
//static NSString *ZPPLastName = @"last_name";
//static NSString *ZPPUserEmail = @"email";
//static NSString *ZPPPhoneNumber = @"phone_number";
//static NSString *ZPPAPIToken = @"api_token";
//static NSString *ZPPUserID = @"id";


@interface ZPPUser ()

//
//@property (copy, nonatomic) NSString *firstName;//
//@property (copy, nonatomic) NSString *lastName;//
//@property (copy, nonatomic) NSString *email;//
//@property (copy, nonatomic) NSString *phoneNumber;//
//@property (copy, nonatomic) NSString *password;//
@property (copy, nonatomic) NSString *apiToken;//
@property (copy, nonatomic) NSString *userID;//




@end

@implementation ZPPUser



//- (instancetype)initWithDict:(NSDictionary *)dict {
//    self = [super init];
//    if (self) {
//        //   self.apiToken = [dict objectForKey:ZPPAPIToken];
//        
//        if(dict[ZPPAPIToken]){
//            self.apiToken = dict[ZPPAPIToken];
//        }
//        if( dict[ZPPFirstName]) {
//            self.firstName = [dict objectForKey:ZPPFirstName];
//        }
//        if(dict[ZPPLastName]){
//            self.lastName = dict[ZPPLastName];
//        }
//        if(dict [ZPPUserEmail]) {
//            self.email = [dict objectForKey:ZPPUserEmail];
//        }
//        
//        if(dict[ZPPPhoneNumber]) {
//            self.phoneNumber = dict[ZPPPhoneNumber];
//        }
//        
//        if(dict[ZPPUserID]) {
//            self.phoneNumber = dict[ZPPPhoneNumber];
//        }
//        
//    }
//    return self;
//}


- (instancetype)initWihtName:(NSString *)name
                    lastName:(NSString *)lastName
                       email:(NSString *)email
                 phoneNumber:(NSString *)phoneNumber
                      userID:(NSString *)userID
                      apiKey:(NSString *)apiKey
                   promocode:(NSString *)promocode;
{
    self = [super init];
    if (self) {
        self.firstName = name;
        self.lastName = lastName;
        self.email = email;
        self.phoneNumber = phoneNumber;
        self.userID = userID;
        self.apiToken = apiKey;
        self.promoCode = promocode;
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [[ZPPUser alloc] init];
    if (self) {
        
        self.firstName = [coder decodeObjectForKey:ZPPFirstName];
        self.lastName = [coder decodeObjectForKey:ZPPLastName];
        self.email = [coder decodeObjectForKey:ZPPUserEmail];
        self.apiToken = [coder decodeObjectForKey:ZPPAPIToken];
        self.phoneNumber = [coder decodeObjectForKey:ZPPPhoneNumber];
        self.userID = [coder decodeObjectForKey:ZPPUserID];
        
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    
    [coder encodeObject:self.firstName forKey:ZPPFirstName];
    [coder encodeObject:self.lastName forKey:ZPPLastName];
    [coder encodeObject:self.email forKey:ZPPUserEmail];
    [coder encodeObject:self.apiToken forKey:ZPPAPIToken];
    [coder encodeObject:self.phoneNumber forKey:ZPPPhoneNumber];
    [coder encodeObject:self.userID forKey:ZPPUserID];
}




@end
