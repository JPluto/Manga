//
//  MangaAppDelegate.m
//  Manga
//
//  Created by Hidde Jansen on 03-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import "MangaAppDelegate.h"

@implementation MangaAppDelegate


@synthesize window=_window;

@synthesize navigationController=_navigationController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Add the navigation controller's view to the window and display.
    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];
	return YES;
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
    [_navigationController release];
    [super dealloc];
}

@end

#pragma mark UINavigationbar hack

@interface UINavigationBar(CustomImage)
+ (void) initImageDictionary;
- (void) drawRect:(CGRect)rect;
- (void) setImage:(UIImage*)image;
@end


//Global dictionary for recording background image
static NSMutableDictionary *navigationBarImages = NULL;

@implementation UINavigationBar(CustomImage)
//Overrider to draw a custom image

+ (void)initImageDictionary
{
    if(navigationBarImages==NULL){
        navigationBarImages=[[NSMutableDictionary alloc] init];
    }   
}

- (void)drawRect:(CGRect)rect
{
    NSString *imageName=[navigationBarImages objectForKey:[NSValue valueWithNonretainedObject: self]];
    if (imageName==nil) {
        imageName=@"headerbar.png";
    }
    UIImage *image = [UIImage imageNamed: imageName];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
}

//Allow the setting of an image for the navigation bar
- (void)setImage:(UIImage*)image
{
    [navigationBarImages setObject:image forKey:[NSValue valueWithNonretainedObject: self]];
}
@end

