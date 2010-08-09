//
//  CycleHireAppDelegate.m
//  CycleHire
//
//  Created by Alexander Baxevanis on 17/03/2010.
//  Copyright Alexander Baxevanis 2010. All rights reserved.
//

#import "CycleHireAppDelegate.h"
#import "MapViewController.h"
#import "AttractionListViewController.h"
#import "AttractionCategoryViewController.h"
#import "LocationPopupViewController.h"
#import "FavouritesListViewController.h"
#import "InfoViewController.h"
#import "InfoWebViewController.h"

#import <Three20/Three20.h>

@implementation CycleHireAppDelegate

#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	
	TTNavigator* navigator = [TTNavigator navigator];
	navigator.persistenceMode = TTNavigatorPersistenceModeNone;
	
	TTURLMap* map = navigator.URLMap;
	
	[[TTNavigator navigator] setOpensExternalURLs:YES];

	[map from:@"cyclehire://attractions/category/(initWithTitle:)/(attractionsCSV:)" toSharedViewController:([AttractionListViewController class])];
	[map from:@"cyclehire://attractions/" toSharedViewController:([AttractionCategoryViewController class])];
	[map from:@"cyclehire://map/" toSharedViewController:([MapViewController class])];
	
	// TODO: initWithName is dummy so we can also pass query - is there any other way?
	[map from:@"cyclehire://favourites/(initWithName:)" toSharedViewController:([FavouritesListViewController class])];

	[map from:@"cyclehire://information/" toSharedViewController:([InfoViewController class])];

	[navigator openURLAction:[TTURLAction actionWithURLPath:@"cyclehire://map/"]];
	
	if([launchOptions objectForKey:UIApplicationLaunchOptionsLocalNotificationKey] != nil) {
		[[[TTNavigator navigator].URLMap objectForURL:@"cyclehire://map/"]
			performSelectorOnMainThread:@selector(findMe) withObject:nil waitUntilDone:FALSE];
	}
	
	return TRUE;
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[[TTNavigator navigator].URLMap objectForURL:@"cyclehire://map/"] saveAppState];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[[TTNavigator navigator].URLMap objectForURL:@"cyclehire://map/"] saveAppState];
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	NSLog(@"didReceiveLocalNotification");
	if (application.applicationState == UIApplicationStateInactive) {
		[[[TTNavigator navigator].URLMap objectForURL:@"cyclehire://map/"] returnToMapAndFindMe];
	} else if (application.applicationState == UIApplicationStateActive) {
		UIAlertView *simulateLocalNotification = 
		[[UIAlertView alloc] initWithTitle:@"Reminder" 
								   message:notification.alertBody
								  delegate:self 
						 cancelButtonTitle:@"Close" 
						 otherButtonTitles:notification.alertAction, nil];
		[simulateLocalNotification show];
		[simulateLocalNotification release];
	}
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == alertView.firstOtherButtonIndex) {
		[[[TTNavigator navigator].URLMap objectForURL:@"cyclehire://map/"] returnToMapAndFindMe];
	}
}
	
@end

