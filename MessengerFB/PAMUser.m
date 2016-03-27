//
//  PAMUser.m
//  MessengerFB
//
//  Created by iMac309 on 26.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "PAMUser.h"

@implementation PAMUser

- (instancetype)initWithAuthData:(FAuthData *) authData {
    self = [super init];
    if (self) {
        self.uid = authData.uid;
        self.email = authData.providerData[@"email"];
        self.firstName = [authData.providerData[@"cachedUserProfile"] objectForKey:@"first_name"];
        self.lastName = [authData.providerData[@"cachedUserProfile"] objectForKey:@"last_name"];
        self.avatarURL = authData.providerData[@"profileImageURL"];
    }
    return self;
}

- (instancetype)initWithDataSnapshot:(FDataSnapshot *) snapshot {
    self = [super init];
    if (self) {
        self.uid = snapshot.value[@"uid"];
        self.email = snapshot.value[@"email"];
        self.firstName = snapshot.value[@"firstName"];
        self.lastName = snapshot.value[@"lastName"];
        self.avatarURL = snapshot.value[@"avatarURL"];
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"\nUID: %@ \nEmail: %@\nUset name: %@ %@ \nAvatarURL: %@",
            self.uid, self.email, self.firstName, self.lastName, self.avatarURL];
}

#pragma mark - Helpers
- (NSString *)prettyName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSDictionary *)userInfo {
    NSDictionary *userInfo = @{    @"uid": self.uid,
                                 @"email": self.email,
                            @"firstName" : self.firstName,
                             @"lastName" : self.lastName,
                            @"avatarURL" : self.avatarURL};
    return userInfo;
}

- (UIImage *)avatarImage {
    NSURL *url = [NSURL URLWithString: self.avatarURL];
    NSData  *data = [NSData dataWithContentsOfURL: url];
    return [UIImage imageWithData:data];
}

#pragma mark - NSCoding
- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.uid forKey:@"uid"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    self.uid = [aDecoder decodeObjectForKey:@"uid"];
    self.email = [aDecoder decodeObjectForKey:@"email"];
    self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
    self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
    self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
    return self;
}

@end
