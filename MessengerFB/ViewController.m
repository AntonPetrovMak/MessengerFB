//
//  ViewController.m
//  MessengerFB
//
//  Created by iMac309 on 24.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(strong, nonatomic) Firebase *ref;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[Firebase alloc] initWithUrl:@"https://shining-heat-3690.firebaseio.com"];

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
-(void)loginButtonClicked {
    FBSDKLoginManager *facebookLogin = [[FBSDKLoginManager alloc] init];
    [facebookLogin logInWithReadPermissions:@[@"email"]
                                    handler:^(FBSDKLoginManagerLoginResult *facebookResult, NSError *facebookError) {

                                        if (facebookError) {
                                            NSLog(@"Facebook login failed. Error: %@", facebookError);
                                        } else if (facebookResult.isCancelled) {
                                            NSLog(@"Facebook login got cancelled.");
                                        } else {
                                            [self loginInFirebase];
                                        }
                                    }];
}


- (void)loginInFirebase {
    NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
    
    [self.ref authWithOAuthProvider:@"facebook" token:accessToken
                withCompletionBlock:^(NSError *error, FAuthData *authData) {
                    
                    NSLog(@"authData: %@", authData);
                    if (error) {
                        NSLog(@"Login failed. %@", error);
                    } else {
                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                           parameters:@{@"fields": @"picture, first_name, last_name"}]
                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                             NSLog(@"%@", result);
                             if (!error) {
                                 
                                 NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",result[@"id"]];
                                 
                                 
                                 NSLog(@"Logged in! %@", authData);
                                 NSDictionary *userInfo = @{@"first_name" : result[@"first_name"],
                                                            @"last_name" : result[@"last_name"],
                                                            @"pictureURL": url };
                                 
                                 
                                 NSDictionary *user = @{@"uid": authData.uid,
                                                        @"userInfo": userInfo };
                                 Firebase *usersRef = [self.ref childByAppendingPath: @"users"];
                                 [usersRef updateChildValues:user];
                                 //[usersRef setValue: user];
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
