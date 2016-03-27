//
//  PAMLoginViewController.m
//  MessengerFB
//
//  Created by iMac309 on 24.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "PAMLoginViewController.h"

@interface PAMLoginViewController ()

@property(strong, nonatomic) Firebase *ref;

@end

@implementation PAMLoginViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.ref = [[Firebase alloc] initWithUrl:@"https://shining-heat-3690.firebaseio.com"];
    self.loginButton.delegate = self;
    self.loginButton.readPermissions = @[@"public_profile", @"email"];
    [self.view addSubview:self.loginButton];
    
}

- (void)authenticationInFirebase {
    NSString *accessToken = [[FBSDKAccessToken currentAccessToken] tokenString];
    __weak PAMLoginViewController *weakSelf = self;
    
    [self.ref authWithOAuthProvider:@"facebook" token:accessToken
                withCompletionBlock:^(NSError *error, FAuthData *authData) {
                    if (error) {
                        NSLog(@"Login failed. %@", error);
                    } else {
                        PAMUser *currentUser = [[PAMUser alloc] initWithAuthData:authData];
                        NSLog(@"%@", currentUser);
                        
                        Firebase *usersRef = [weakSelf.ref childByAppendingPath: [NSString stringWithFormat:@"users/%@", currentUser.uid]];
                        [usersRef setValue: [currentUser userInfo]];
                        
                        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:currentUser];
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"userInfo"];
                        [weakSelf.loginIndicator stopAnimating];
                        
                        UINavigationController *NC = (UINavigationController *)[weakSelf.storyboard instantiateViewControllerWithIdentifier:@"UsersNavigationController"];
                        [weakSelf presentViewController:NC animated:YES completion:nil];
                    }
                }];
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
