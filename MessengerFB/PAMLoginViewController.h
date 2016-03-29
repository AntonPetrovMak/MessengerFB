//
//  PAMLoginViewController.h
//  MessengerFB
//
//  Created by iMac309 on 24.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <Firebase/Firebase.h>
#import "PAMUser.h"

@interface PAMLoginViewController : UIViewController <FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *loginIndicator;

@end

