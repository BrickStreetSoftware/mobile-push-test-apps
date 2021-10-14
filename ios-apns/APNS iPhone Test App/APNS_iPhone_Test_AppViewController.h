//
//  APNS_iPhone_Test_AppViewController.h
//  APNS iPhone Test App
//
//  Created by Chris Maeda on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface APNS_iPhone_Test_AppViewController : UIViewController {
    
    UITextView *deviceTokenText;    // display device token
    UITextView *messagesText;       // display messages
    NSDateFormatter *dateFormatter;
}

@property (nonatomic, retain) IBOutlet UITextView *deviceTokenText;
@property (nonatomic, retain) IBOutlet UITextView *messagesText;

- (IBAction)testButtonPressed:(id)sender;
- (IBAction)clearButtonPressed:(id)sender;

// called by app delegate when device token is acquired
- (void)registeredWithDeviceToken:(NSData *)devToken;
// called by app delegate if device token cannot be acquired
- (void)failedToRegisterDeviceToken:(NSError *)err;
// called by app delegate when a remote notification is received
- (void)didReceiveRemoteNotification:(NSDictionary *)remoteNotif;

// helper methods
- (void)initDateFormatter;

@end
