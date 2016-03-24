//
//  ViewController.m
//  MessengerFB
//
//  Created by iMac309 on 24.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loginButton = [[FBSDKLoginButton alloc] init];
    self.loginButton.center = self.view.center;
    self.loginButton.delegate = self;
    //self.loginButton.readPermissions = @[@"public_profile", @"email", @"user_friends"];
    [self.loginButton
     addTarget:self
     action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:self.loginButton];
}

// Once the button is clicked, show the login dialog
-(void)loginButtonClicked
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    [login logInWithReadPermissions: @[@"public_profile"]
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                if (error) {
                                    NSLog(@"Process error");
                                } else {
                                    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                                       parameters:@{@"fields": @"picture, first_name, last_name"}]
                                     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                                         NSLog(@"%@", result);
                                         if (!error) {
                                             
                                             NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",result[@"id"]]];
                                             NSData  *data = [NSData dataWithContentsOfURL:url];
                                             UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
                                             imageView.backgroundColor =[UIColor redColor];
                                             imageView.image = [UIImage imageWithData:data];
                                             [self.view addSubview:imageView];
                                             
                                         }
                                         else{
                                             NSLog(@"%@", [error localizedDescription]);
                                         }
                                     }];
                                }
                                
                            }];
}


#pragma mark - FBSDKLoginButtonDelegate

- (void)  loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    NSLog(@"%s", __PRETTY_FUNCTION__);
    
    NSLog(@"Result: %@", result);
}
- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"%s", __PRETTY_FUNCTION__);
}

@end
