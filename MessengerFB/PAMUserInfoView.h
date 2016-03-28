//
//  PAMUserInfoView.h
//  MessengerFB
//
//  Created by iMac309 on 28.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PAMUserInfoView : UIView

@property(strong, nonatomic) IBOutlet UIImageView *avatar;
@property(strong, nonatomic) IBOutlet UILabel *name;

-(void)setAvatarImage:(UIImage *)avatar andName:(NSString *)name;

@end
