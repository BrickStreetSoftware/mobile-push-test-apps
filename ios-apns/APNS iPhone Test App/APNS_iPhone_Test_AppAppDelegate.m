//
//  APNS_iPhone_Test_AppAppDelegate.m
//  APNS iPhone Test App
//
//  Created by Chris Maeda on 9/1/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "APNS_iPhone_Test_AppAppDelegate.h"

#import "APNS_iPhone_Test_AppViewController.h"
#import "SetupViewController.h"

@implementation APNS_iPhone_Test_AppAppDelegate


@synthesize window=_window;
@synthesize viewController=_viewController;

@synthesize myDeviceToken;
@synthesize myDeviceTokenError;

@synthesize myEmailAddress;
@synthesize myAltCustomerId;
@synthesize apiServerUrl;
@synthesize apiServerUser;
@synthesize apiServerPass;

//
// application:didFinishLaunchingWithOptions:
//
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
     
    // register with APNS to get device token
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert|UIRemoteNotificationTypeBadge|UIRemoteNotificationTypeSound)
     ];
    
    // reset badge indicator
    application.applicationIconBadgeNumber = 0;

    // check to see if we were launched with a remote notification
    NSDictionary *remoteNotif = [launchOptions objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey];
    if (remoteNotif) {        
        // pass alert to view controller
        [_viewController didReceiveRemoteNotification:remoteNotif];
    }
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

//
// HANDLE REMOTE NOTIFICATION WHILE APP IS RUNNING
//
- (void)application:(UIApplication *)app didReceiveRemoteNotification:(NSDictionary *)userInfo
{
    // reset badge indicator
    app.applicationIconBadgeNumber = 0;

    // pass alert to view controller
    [_viewController didReceiveRemoteNotification:userInfo];
}

//
// called when device token is available
//
- (void)application:(UIApplication *)app didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    // save device token in delegate
    if (myDeviceToken) {
        // _myDeviceToken has copy semantics so dealloc old copy
        [myDeviceToken dealloc];
        myDeviceToken = NULL;
    }
    if (myDeviceTokenError) {
        [myDeviceTokenError dealloc];
        myDeviceTokenError = NULL;
    }
    myDeviceToken = [deviceToken copy];
    
    // TODO UPDATE SERVER IF DEVICE TOKEN CHANGED

    // NOTE This is a test program so we do not send the device token to server here.
    // Instead we do it in the Setup View after the user specifies the
    // location url of the server to update.
    
    // send device token to main view controller...
    [_viewController registeredWithDeviceToken:deviceToken];
    
    // update setup view if it is loaded
    if (_setupViewController) {
        [_setupViewController gotDeviceToken:deviceToken];
    }
}

//
// failed to get device token
//
- (void)application:(UIApplication *)app didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    // save error
    if (myDeviceToken) {
        [myDeviceToken dealloc];
        myDeviceToken = NULL;
    }
    if (myDeviceTokenError) {
        [myDeviceTokenError dealloc];
        myDeviceTokenError = NULL;
    }
    myDeviceTokenError = [error copy];
    
    // tell view controller...
    [_viewController failedToRegisterDeviceToken:error];
    
    // tell setup if loaded
    if (_setupViewController) {
        [_setupViewController failedToRegisterDeviceToken:error];
    }
}


-(void)connectToApi:(SetupViewController *)setup
{
    // populate info from setup view
    if (myEmailAddress) {
        [myEmailAddress dealloc];
        myEmailAddress = NULL;
    }
    myEmailAddress = [setup.myEmailAddress.text copy];
    
    if (myAltCustomerId) {
        [myAltCustomerId dealloc];
        myAltCustomerId = NULL;
    }
    myAltCustomerId = [setup.myAltCustomerId.text copy];
    
    if (apiServerUrl) {
        [apiServerUrl dealloc];
        apiServerUrl = NULL;
    }
    apiServerUrl = [setup.apiServerUrl.text copy];
    
    if (apiServerUser) {
        [apiServerUser dealloc];
        apiServerUser = NULL;
    }
    apiServerUser = [setup.apiServerUser.text copy];
    
    if (apiServerPass) {
        [apiServerPass dealloc];
        apiServerPass = NULL;
    }
    apiServerPass = [setup.apiServerPass.text copy];
    
    
}


- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    /*
     Called when the application is about to terminate.
     Save data if appropriate.
     See also applicationDidEnterBackground:.
     */
}

- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

@end
