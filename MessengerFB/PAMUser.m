//
//  PAMUser.m
//  MessengerFB
//
//  Created by iMac309 on 26.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "PAMUser.h"

@implementation PAMUser

- (instancetype) initWithFirstName:(NSString *) firstName lastName:(NSString *) lastName avatarURL:(NSString *) avatarURL {
    self = [super init];
    if (self) {
        self.firstName = firstName;
        self.lastName = lastName;
        self.avatarURL = avatarURL;
    }
    return self;
}

- (NSString *) description {
    return [NSString stringWithFormat:@"\nUset name: %@ %@ \nAvatarURL: %@", self.firstName, self.lastName, self.avatarURL];
}

#pragma mark - Helpers
- (NSString *)prettyName {
    return [NSString stringWithFormat:@"%@ %@", self.firstName, self.lastName];
}

- (NSDictionary *)userInfo {
    NSDictionary *userInfo = @{@"firstName" : self.firstName,
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
    [aCoder encodeObject:self.firstName forKey:@"firstName"];
    [aCoder encodeObject:self.lastName forKey:@"lastName"];
    [aCoder encodeObject:self.avatarURL forKey:@"avatarURL"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [self init];
    self.firstName = [aDecoder decodeObjectForKey:@"firstName"];
    self.lastName = [aDecoder decodeObjectForKey:@"lastName"];
    self.avatarURL = [aDecoder decodeObjectForKey:@"avatarURL"];
    return self;
}

@end
