//
//  PAMUser.h
//  MessengerFB
//
//  Created by iMac309 on 26.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>


@interface PAMUser : NSObject <NSCoding>

@property(strong, nonatomic) NSString *uid;
@property(strong, nonatomic) NSString *email;
@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *lastName;
@property(strong, nonatomic) NSString *avatarURL;

- (NSString *)prettyName;

- (instancetype)initWithAuthData:(FAuthData *) authData;
- (instancetype)initWithDataSnapshot:(FDataSnapshot *) snapshot;
- (NSDictionary *)userInfo;
- (UIImage *)avatarImage;

@end
