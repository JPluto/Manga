//
//  MangaAppDelegate.h
//  Manga
//
//  Created by Hidde Jansen on 03-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MangaAppDelegate : NSObject <UIApplicationDelegate> {

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet UINavigationController *navigationController;

@end
