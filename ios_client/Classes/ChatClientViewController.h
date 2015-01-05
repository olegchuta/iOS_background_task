//
//  ChatClientViewController.h
//  ChatClient
//
//  Created by cesarerocchi on 5/27/11.
//  Copyright 2011 studiomagnolia.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/NSTimer.h>

@interface ChatClientViewController : UIViewController <NSStreamDelegate> {

	NSInputStream	*inputStream;
	NSOutputStream	*outputStream;
}

@property (nonatomic, retain) IBOutlet UIView *joinView;
@property (nonatomic, retain) NSInputStream *inputStream;
@property (nonatomic, retain) NSOutputStream *outputStream;
@property NSTimer *timer;

- (void) initNetworkCommunication;
- (void) sendClientInvitation;
- (void) hideApplication;
- (void) initSendMessageTimer:(int)interval;
- (IBAction) sendMessage;
- (NSString *) getCurrentTime;

@end

