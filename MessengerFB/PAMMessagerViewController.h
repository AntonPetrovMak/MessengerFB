//
//  PAMMessagerViewController.h
//  MessengerFB
//
//  Created by iMac309 on 27.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#include <JSQMessagesViewController/JSQMessagesViewController.h>
#import "JSQMessagesBubbleImage.h"
#import <Firebase/Firebase.h>
#import "PAMUser.h"

@interface PAMMessagerViewController : JSQMessagesViewController

@property (strong, nonatomic) JSQMessagesBubbleImage *outgoingBubbleImageView;
@property (strong, nonatomic) JSQMessagesBubbleImage *incomingBubbleImageView;
@property(strong, nonatomic) Firebase *rootRef;
@property(strong, nonatomic) Firebase *messageRef;
@property(strong, nonatomic) PAMUser *currentUser;
@property(strong, nonatomic) PAMUser *interlocutor;

@end
