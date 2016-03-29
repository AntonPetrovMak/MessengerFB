//
//  PAMUsersTableViewController.m
//  MessengerFB
//
//  Created by iMac309 on 26.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "PAMUsersTableViewController.h"
#import <Firebase/Firebase.h>

@interface PAMUsersTableViewController ()

@property(strong, nonatomic) Firebase *ref;
@property(strong, nonatomic) PAMUser *currentUser;
@property(strong, nonatomic) NSMutableArray *arrayWithUser;

@end

@implementation PAMUsersTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.ref = [[Firebase alloc] initWithUrl:@"https://shining-heat-3690.firebaseio.com"];
    self.arrayWithUser =[NSMutableArray new];
    NSData *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:@"userInfo"];
    
    if(userInfo) {
        self.currentUser = (PAMUser *)[NSKeyedUnarchiver unarchiveObjectWithData:userInfo];
    } else {
        self.currentUser = [PAMUser new];
    }
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self action:@selector(upDateTable) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    [self.refreshControl beginRefreshing];
    [self observeUsers];
}

#pragma mark - Helpers

- (void)upDateTable {
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (void)observeUsers {
    __weak PAMUsersTableViewController *weakSelf = self;
    [[self.ref childByAppendingPath:@"users"]observeEventType: FEventTypeChildAdded
                                                    withBlock: [self addUserFromFirebase:weakSelf]
                                              withCancelBlock:^(NSError *error) {
                                                  NSLog(@"observeEventType: %@", error.description);
                                              }];
}

- (void(^)(FDataSnapshot *snapshot)) addUserFromFirebase:(PAMUsersTableViewController *) weakSelf {
    return ^(FDataSnapshot *snapshot) {
        PAMUser *user = [[PAMUser alloc] initWithDataSnapshot:snapshot];
        [weakSelf.arrayWithUser addObject: user];
        [weakSelf.refreshControl endRefreshing];
        [weakSelf.tableView reloadData];
    };
}

#pragma mark - Action
- (IBAction)actionLogOut:(UIBarButtonItem *)sender {
    [[FBSDKLoginManager new] logOut];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userInfo"];
    UIViewController *loginViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PAMLoginViewController"];
    [self presentViewController:loginViewController animated:YES completion:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.arrayWithUser count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    PAMUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[PAMUserTableViewCell reuseIdentifire]];
    if(!cell) {
        cell = [[PAMUserTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                           reuseIdentifier:[PAMUserTableViewCell reuseIdentifire]];
    }
    PAMUser *user = (PAMUser *)[self.arrayWithUser objectAtIndex:indexPath.row];
    cell.userName.text = [NSString stringWithFormat:@"%@", [user prettyName]];
    cell.avatar.image = [user avatarImage];
    [cell.avatar.layer setCornerRadius:30.f];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"MessagerSegue"]) {
        PAMMessagerViewController *messagerViewController = [segue destinationViewController];
        NSInteger selectedRow = [[self.tableView indexPathForSelectedRow] row];
        PAMUser *user = [self.arrayWithUser objectAtIndex:selectedRow];

        self.navigationItem.backBarButtonItem.title = user.prettyName;
        //self.navigationItem.backBarButtonItem.image = [user avatarImage];
        messagerViewController.currentUser = self.currentUser;
        messagerViewController.interlocutor = user;
        messagerViewController.senderId = self.currentUser.uid;
        messagerViewController.senderDisplayName = self.currentUser.prettyName;
    }
}


@end
