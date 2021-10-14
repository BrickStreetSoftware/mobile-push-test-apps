//
//  SetupViewController.m
//  APNS iPhone Test App
//
//  Created by Chris Maeda on 9/29/14.
//
//

#import "SetupViewController.h"
#import "APNS_iPhone_Test_AppAppDelegate.h"

@interface SetupViewController ()

@end

@implementation SetupViewController

@synthesize myEmailAddress;
@synthesize myAltCustomerId;
@synthesize myDeviceToken;
@synthesize apiServerUrl;
@synthesize apiServerUser;
@synthesize apiServerPass;
@synthesize statusLabel;

- (void)gotDeviceToken:(NSData *)deviceToken
{
    // convert device token to string
    NSString *myDeviceTokenStr = [[deviceToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];
    myDeviceTokenStr = [myDeviceTokenStr stringByReplacingOccurrencesOfString:@" " withString:@""];

    // store device token string in widget
    myDeviceToken.text = myDeviceTokenStr;
    
    _deviceTokenValid = TRUE;
}

- (void)failedToRegisterDeviceToken:(NSError *)error
{
    NSString *errmsg = [[NSString alloc]
                        initWithFormat:@"Error: %@", error.localizedDescription];
    
    // store error msg in widget
    myDeviceToken.text = errmsg;
    
    _deviceTokenValid = FALSE;
}

- (IBAction)connectToApi:(id)sender
{
    // check server args
    NSString *serverURL = apiServerUrl.text;
    NSString *serverUser = apiServerUser.text;
    NSString *serverPass = apiServerPass.text;
    if (serverURL == NULL || serverUser == NULL || serverPass == NULL) {
        statusLabel.text = @"API Server info must be specified.";
        return;
    }
    // check customer info
    NSString *custEmail = myEmailAddress.text;
    NSString *custAltId = myAltCustomerId.text;
    if (custEmail == NULL || custAltId == NULL) {
        statusLabel.text = @"Email address or Alt Customer ID must be specified.";
        return;
    }
    // device token should be valid, but we relax this constraint so that
    // we can test web service access without using a physical device
    NSString *deviceToken =  myDeviceToken.text;
    if (deviceToken == NULL) {
        statusLabel.text = @"No value for device token.";
        return;
    }
    
    // we have valid data; send to the api server
    APNS_iPhone_Test_AppAppDelegate *appDelegate = (APNS_iPhone_Test_AppAppDelegate *)
    [UIApplication sharedApplication].delegate;
    [appDelegate connectToApi:self];
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
