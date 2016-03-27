//
//  PAMMessagerViewController.m
//  MessengerFB
//
//  Created by iMac309 on 27.03.16.
//  Copyright (c) 2016 Antonpetrovmak. All rights reserved.
//

#import "PAMMessagerViewController.h"
#import "JSQSystemSoundPlayer/JSQSystemSoundPlayer.h"
#import "JSQSystemSoundPlayer+JSQMessages.h"
#import "JSQMessagesBubbleImageFactory.h"
#import "JSQMessagesAvatarImageFactory.h"
#import "JSQMessagesCollectionViewCell.h"
#import "JSQMessagesAvatarImage.h"
#import "JSQMessageData.h"
#import "JSQMessage.h"

@interface PAMMessagerViewController ()

@property(strong, nonatomic) NSMutableArray *messages;


@end

@implementation PAMMessagerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.messages = [NSMutableArray new];
    [self setupBubbles];
    self.rootRef = [[Firebase alloc] initWithUrl:@"https://shining-heat-3690.firebaseio.com"];
    self.messageRef = [self.rootRef childByAppendingPath:@"messages"];
    self.collectionView.backgroundColor = [UIColor colorWithRed:234/255.f green:234/255.f blue:234/255.f alpha:1];
    self.inputToolbar.contentView.backgroundColor = [UIColor colorWithRed:21/255.f green:102/255.f blue:82/255.f alpha:1];
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
}

- (void)viewDidAppear:(BOOL)animated {
    [self observeMessages];
}

- (void)setupBubbles {
    JSQMessagesBubbleImageFactory *factory = [JSQMessagesBubbleImageFactory new];
    self.outgoingBubbleImageView = [factory outgoingMessagesBubbleImageWithColor:[UIColor colorWithRed:254/255.f green:254/255.f blue:254/255.f alpha:1]];
    self.incomingBubbleImageView = [factory incomingMessagesBubbleImageWithColor:[UIColor colorWithRed:209/255.f green:208/255.f blue:209/255.f alpha:1]];
}

- (void)addMessageUId:(NSString *) uid test:(NSString *) test {
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:uid senderDisplayName:@"Test user" date:[NSDate date] text:test];
    [self.messages addObject:message];
}

- (void) observeMessages {
    FQuery *messagesQuery = [self.messageRef queryLimitedToLast:25];
    [messagesQuery observeEventType:FEventTypeChildAdded
     andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
         [self addMessageUId:snapshot.value[@"senderId"] test: snapshot.value[@"text"]];
         [self finishReceivingMessage];
     }
                    withCancelBlock:^(NSError *error) {
                        if(error) {
                            NSLog(@"An error occurred while reading messages: %@", error);
                        }
                    }];
}

#pragma mark - JSQMessageData

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    Firebase *itemRef = [self.messageRef childByAutoId];
    [itemRef setValue:@{@"text": text,
                        @"senderId": senderId}];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessage];

}

- (void)didPressAccessoryButton:(UIButton *)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"Media messages"
                                                       delegate:nil
                                              cancelButtonTitle:@"Cancel"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"Send photo", @"Send location", @"Send video", nil];
    
    [sheet showFromToolbar:self.inputToolbar];
}

- (id<JSQMessageBubbleImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView messageBubbleImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if([message.senderId isEqualToString: self.senderId]) {
        return self.outgoingBubbleImageView;
    } else {
        return self.incomingBubbleImageView;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessagesCollectionViewCell *cell = (JSQMessagesCollectionViewCell *)[super collectionView:collectionView cellForItemAtIndexPath:indexPath];
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    if (!message.isMediaMessage) {
        if ([message.senderId isEqualToString:self.senderId]) {
            cell.textView.textColor = [UIColor colorWithRed:89/255.f green:89/255.f blue:89/255.f alpha:1];
        }
        else {
            cell.textView.textColor = [UIColor blackColor];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                               NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages objectAtIndex:indexPath.item];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.messages count];
}

#pragma mark - Actions
- (IBAction)fakeSender:(id)sender {
    Firebase *itemRef = [self.messageRef childByAutoId];
    [itemRef setValue:@{@"text": @"test test from fake user",
                        @"senderId": @"1234567890"}];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessage];
}
@end
