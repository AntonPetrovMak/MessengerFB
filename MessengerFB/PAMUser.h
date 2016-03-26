//
//  PAMUser.h
//  MessengerFB
//
//  Created by iMac309 on 26.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface PAMUser : NSObject <NSCoding>

@property(strong, nonatomic) NSString *firstName;
@property(strong, nonatomic) NSString *lastName;
@property(strong, nonatomic) NSString *avatarURL;

- (NSString *)prettyName;

- (instancetype)initWithFirstName:(NSString *) firstName lastName:(NSString *) lastName avatarURL:(NSString *) avatarURL;
- (NSDictionary *)userInfo;
- (UIImage *)avatarImage;

@end
