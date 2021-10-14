//
//  APNS_iPhone_Test_AppViewController.m
//  APNS iPhone Test App
//
//  Created by Chris Maeda on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APNS_iPhone_Test_AppViewController.h"

@implementation APNS_iPhone_Test_AppViewController
@synthesize deviceTokenText;
@synthesize messagesText;

- (void)dealloc
{
    [deviceTokenText release];
    [messagesText release];
    [super dealloc];
}

- (void)initDateFormatter
{
    if (dateFormatter == 0) {
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setLocale:[NSLocale currentLocale]];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterMediumStyle];
    }
}

- (IBAction)clearButtonPressed:(id)sender
{
    messagesText.text = @"";
}

- (IBAction)testButtonPressed:(id)sender
{
    if (dateFormatter == 0) {
        [self initDateFormatter];
    }
    
    NSString *msg = [[NSString alloc]
                     initWithFormat:@"%@: Test message\r\n", 
                     [dateFormatter stringFromDate:[NSDate date]]
                     ];
 
    // add new msg to text view
    NSString *currtext = [messagesText text];
    if (currtext == nil) {
        currtext = msg;
    }
    else {
        currtext = [currtext stringByAppendingString:msg];
    }
    
    messagesText.text = currtext;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}


//
// MANAGE DEVICE TOKENS
//

-(void)registeredWithDeviceToken:(NSData *)devToken
{
    // format device token and display in text box
    
    NSString *deviceToken = [[devToken description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]];    
    deviceToken = [deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // save in control
    deviceTokenText.text = deviceToken;
}

-(void)failedToRegisterDeviceToken:(NSError *)err
{
    NSString *errmsg = [[NSString alloc]
                        initWithFormat:@"Error: %@", err.localizedDescription];
    
    deviceTokenText.text = errmsg;
}

//
// HANDLE REMOTE NOTIFICATION
//

-(void)didReceiveRemoteNotification:(NSDictionary *)remoteNotif
{
    if (dateFormatter == 0) {
        [self initDateFormatter];
    }

    NSObject * aps = [remoteNotif valueForKey:@"aps"]; 
    NSString * alert = [aps valueForKey:@"alert"];
    
    if (alert == 0) {
        alert = @"NULL";
    }
    
    NSString *msg = [[NSString alloc]
                     initWithFormat:@"%@: %@\r\n", 
                     [dateFormatter stringFromDate:[NSDate date]],
                     alert
                     ];
    
    // add new msg to text view
    NSString *currtext = [messagesText text];
    if (currtext == nil) {
        currtext = msg;
    }
    else {
        currtext = [currtext stringByAppendingString:msg];
    }
    
    messagesText.text = currtext;
}

#pragma mark - View lifecycle

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
}
*/

- (void)viewDidUnload
{
    self.deviceTokenText = nil;
    self.messagesText = nil;
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
