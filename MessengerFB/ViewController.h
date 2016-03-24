//
//  ViewController.h
//  MessengerFB
//
//  Created by iMac309 on 24.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
@interface ViewController : UIViewController <FBSDKLoginButtonDelegate>

@property (strong, nonatomic) IBOutlet FBSDKLoginButton *loginButton;


@end

