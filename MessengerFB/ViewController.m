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
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    [self.view addSubview:self.loginButton];
}

- (void)authenticationInFirebase {
    NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
    
    [self.ref authWithOAuthProvider:@"facebook" token:accessToken
                withCompletionBlock:^(NSError *error, FAuthData *authData) {
                    
                    if (error) {
                        NSLog(@"Login failed. %@", error);
                    } else {
                        [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
                                                           parameters:@{@"fields": @"picture, first_name, last_name"}]
                         startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                             NSLog(@"%@", result);
                             if (!error) {
                                 NSLog(@"Logged in! %@", authData);
                                 NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=normal",result[@"id"]];

                                 PAMUser *currentUser = [[PAMUser alloc] initWithFirstName:result[@"first_name"] lastName:result[@"last_name"] avatarURL:url];
                                 
                                 Firebase *usersRef = [self.ref childByAppendingPath: [NSString stringWithFormat:@"users/%@", authData.uid]];
                                 [usersRef setValue: [currentUser userInfo]];
                                 
                                 
                                 NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
                                 [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfo"];
                                 [self.loginIndicator stopAnimating];
                                 
                                 UINavigationController *NC = (UINavigationController *)[self.storyboard instantiateViewControllerWithIdentifier:@"UsersNavigationController"];
                                 [self presentViewController:NC animated:YES completion:nil];
                             }
                             else{
                                 NSLog(@"%@", [error localizedDescription]);
                             }
                         }];
                        
                    }
                }];
}

- (void(^)(FBSDKGraphRequestConnection *connection, id result, NSError *error)) saveUserData {
    return ^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
        
    };
}


#pragma mark - FBSDKLoginButtonDelegate

- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    NSLog(@"LOG IN!!!");
    if(!error) {
        if (error) {
            NSLog(@"Facebook login failed. Error: %@", error);
        } else if (result.isCancelled) {
            NSLog(@"Facebook login got cancelled.");
        } else {
            [self.loginIndicator startAnimating];
            [self authenticationInFirebase];
            
        }
    }
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    NSLog(@"LOG OUT");
}

@end
