//
//  AppDelegate.m
//  DropIt
//
//  Created by Dean Thibault on 8/18/15.
//  Copyright (c) 2015 Digital Beans. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// Override point for customization after application launch.
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    if (sourceApplication == nil &&
        [[url absoluteString] rangeOfString:@"Documents/Inbox"].location != NSNotFound) // Incoming AirDrop
    {
        NSLog(@"%@ sent from %@ with annotation %@", url, sourceApplication, [annotation description]);
        if (application.protectedDataAvailable) {
			// get the local document directory
			NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
			NSString *documentsDirectory = [paths objectAtIndex:0];

			NSFileManager * fm = [NSFileManager defaultManager];
			
			// create the url to save the file to with document directory and given file name
			NSURL* filePath = [NSURL fileURLWithPath:documentsDirectory];
			NSURL * localUrl = [filePath URLByAppendingPathComponent:[url lastPathComponent]];
			NSError * error;
			// move the temporary file to the documents directory
			BOOL ret = [fm moveItemAtURL:url
								   toURL:localUrl
								   error:&error];
					
			if (!ret) {
				NSLog(@"could not move file from %@ to %@: %@", url, localUrl, error);
			} else {
				[[NSNotificationCenter defaultCenter] postNotificationName:@"DataUpdateNotification" object:nil];
			}
		}
		
		return YES;
    }

    return NO;
}

@end
