//
//  PAMUserInfoView.m
//  MessengerFB
//
//  Created by iMac309 on 28.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "PAMUserInfoView.h"

@implementation PAMUserInfoView

-(void)setAvatarImage:(UIImage *)avatar andName:(NSString *)name {
    self.avatar = [[UIImageView alloc] initWithImage:avatar];
    [self.avatar.layer setCornerRadius:20.f];
    self.name = [[UILabel alloc] init];
    self.name.text = name;
}

@end
