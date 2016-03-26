//
//  PAMUsersTableViewController.h
//  MessengerFB
//
//  Created by iMac309 on 26.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "PAMUserTableViewCell.h"
#import "PAMUser.h"

@interface PAMUsersTableViewController : UITableViewController <UITableViewDataSource>

- (IBAction)actionLogOut:(UIBarButtonItem *)sender;

@end
