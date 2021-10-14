//
//  SetupViewController.h
//  APNS iPhone Test App
//
//  Created by Chris Maeda on 9/29/14.
//
//

#import <UIKit/UIKit.h>

@interface SetupViewController : UIViewController

@property (nonatomic, retain) IBOutlet UITextField *myEmailAddress;
@property (nonatomic, retain) IBOutlet UITextField *myAltCustomerId;
@property (nonatomic, retain) IBOutlet UITextView *myDeviceToken;
@property (nonatomic) BOOL deviceTokenValid;
@property (nonatomic, retain) IBOutlet UITextField *apiServerUrl;
@property (nonatomic, retain) IBOutlet UITextField *apiServerUser;
@property (nonatomic, retain) IBOutlet UITextField *apiServerPass;

@property (nonatomic, retain) IBOutlet UILabel *statusLabel;

- (void)gotDeviceToken:(NSData *)deviceToken;
- (void)failedToRegisterDeviceToken:(NSError *)error;

- (IBAction)connectToApi:(id)sender;

@end
