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
#import "JSQMessagesToolbarButtonFactory.h"
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
    self.rootRef = [[Firebase alloc] initWithUrl:@"https://shining-heat-3690.firebaseio.com"];

    self.messageRef = [self.rootRef childByAppendingPath:[NSString stringWithFormat:@"messages/%@", [self uniqueNameDialog]]];
    self.collectionView.backgroundColor = [UIColor colorWithRed:234/255.f green:234/255.f blue:234/255.f alpha:1];
    self.inputToolbar.contentView.backgroundColor = [UIColor colorWithRed:21/255.f green:102/255.f blue:82/255.f alpha:1];
    
    self.collectionView.collectionViewLayout.incomingAvatarViewSize = CGSizeZero;
    self.collectionView.collectionViewLayout.outgoingAvatarViewSize = CGSizeZero;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self observeMessages];
}

- (NSString *)uniqueNameDialog {
    int curentId = (int)[self.currentUser.uid substringFromIndex:9];
    int interlocutor = (int)[self.interlocutor.uid substringFromIndex:9];
    if(curentId <= interlocutor) {
        return [NSString stringWithFormat:@"%@%@", self.currentUser.uid, self.interlocutor.uid];
    } else {
        return [NSString stringWithFormat:@"%@%@", self.interlocutor.uid, self.currentUser.uid];
    }
}

- (void)addMessageUId:(NSString *) uid test:(NSString *) test date:(NSDate *)date {
    JSQMessage *message = [[JSQMessage alloc] initWithSenderId:uid senderDisplayName:@"Test user" date:date text:test];
    [self.messages addObject:message];
}

- (void)observeMessages {
    FQuery *messagesQuery = [self.messageRef queryLimitedToLast:25];
    [messagesQuery observeEventType:FEventTypeChildAdded
     andPreviousSiblingKeyWithBlock:^(FDataSnapshot *snapshot, NSString *prevKey) {
         
         [self addMessageUId: snapshot.value[@"senderId"]
                        test: snapshot.value[@"text"]
                        date: [NSDate dateWithTimeIntervalSince1970:[snapshot.value[@"date"] integerValue]]];
         [self finishReceivingMessage];
     }
                    withCancelBlock:^(NSError *error) {
                        if(error) {
                            NSLog(@"An error occurred while reading messages: %@", error);
                        }
                    }];
}



#pragma mark - JSQMessageData

- (id<JSQMessageData>)collectionView:(JSQMessagesCollectionView *)collectionView messageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.messages objectAtIndex:indexPath.item];
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.messages count];
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
    [cell.textView.layer setCornerRadius:5.f];
    if (!message.isMediaMessage) {
        if ([message.senderId isEqualToString:self.senderId]) {
           
            cell.cellBottomLabel.textInsets = UIEdgeInsetsMake(0, 0, 0, 20);
            cell.textView.textColor = [UIColor colorWithRed:89/255.f green:89/255.f blue:89/255.f alpha:1];
            cell.textView.backgroundColor = [UIColor colorWithRed:254/255.f green:254/255.f blue:254/255.f alpha:1];
        }
        else {
            cell.cellBottomLabel.textInsets = UIEdgeInsetsMake(0, cell.messageBubbleContainerView.bounds.origin.x + 20, 0, 0);
            cell.textView.textColor = [UIColor blackColor];
            cell.textView.backgroundColor = [UIColor colorWithRed:209/255.f green:208/255.f blue:209/255.f alpha:1];
        }
        
        cell.textView.linkTextAttributes = @{ NSForegroundColorAttributeName : cell.textView.textColor,
                                               NSUnderlineStyleAttributeName : @(NSUnderlineStyleSingle | NSUnderlinePatternSolid) };
    }
    return cell;
}




#pragma mark - AvatarImage

- (id<JSQMessageAvatarImageDataSource>)collectionView:(JSQMessagesCollectionView *)collectionView avatarImageDataForItemAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

#pragma mark - CellBottomLabel

-(NSAttributedString *)collectionView:(JSQMessagesCollectionView *)collectionView attributedTextForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    JSQMessage *message = [self.messages objectAtIndex:indexPath.item];
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    [dateFormatter setDateFormat: @"HH:mm"];
    NSAttributedString *attributedString = [[NSAttributedString alloc] initWithString:[dateFormatter stringFromDate:message.date]];
    return attributedString;
}
- (CGFloat)collectionView:(JSQMessagesCollectionView *)collectionView layout:(JSQMessagesCollectionViewFlowLayout *)collectionViewLayout heightForCellBottomLabelAtIndexPath:(NSIndexPath *)indexPath {
    return 20.f;
}

#pragma mark - Actions
- (IBAction)fakeSender:(id)sender {
    Firebase *itemRef = [self.messageRef childByAutoId];
    [itemRef setValue:@{@"text": [NSString stringWithFormat:@"%@ test text", self.interlocutor.prettyName],
                        @"senderId": self.interlocutor.uid,
                        @"date": @([[NSDate date] timeIntervalSince1970])}];
    
    [JSQSystemSoundPlayer jsq_playMessageSentSound];
    
    [self finishSendingMessage];
}

-(void)didPressSendButton:(UIButton *)button withMessageText:(NSString *)text senderId:(NSString *)senderId senderDisplayName:(NSString *)senderDisplayName date:(NSDate *)date {
    Firebase *itemRef = [self.messageRef childByAutoId];
    [itemRef setValue:@{@"text": text,
                        @"senderId": senderId,
                        @"date": @([[NSDate date] timeIntervalSince1970])}];
    
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
@end
