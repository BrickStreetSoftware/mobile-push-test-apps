//
//  APNS_iPhone_Test_AppAppDelegate.h
//  APNS iPhone Test App
//
//  Created by Chris Maeda on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SetupViewController.h"

@class APNS_iPhone_Test_AppViewController;

@interface APNS_iPhone_Test_AppAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

// main view
@property (nonatomic, retain) IBOutlet APNS_iPhone_Test_AppViewController *viewController;

// setup view
@property (nonatomic, retain) IBOutlet SetupViewController *setupViewController;

//
// application state shared across views
//
@property (copy) NSData *myDeviceToken;
@property (copy) NSError *myDeviceTokenError;

@property (copy) NSString *myEmailAddress;
@property (copy) NSString *myAltCustomerId;
@property (copy) NSString *apiServerUrl;
@property (copy) NSString *apiServerUser;
@property (copy) NSString *apiServerPass;

// called by setup view
-(void)connectToApi:(SetupViewController *)setup;

@end
