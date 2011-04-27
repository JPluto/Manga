//
//  MangaViewController.h
//  Manga
//
//  Created by Hidde Jansen on 29-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeavesViewController.h"
#import "FileUtils.h"
#import "ComicImageView.h"

@interface MangaViewController : LeavesViewController<LeavesViewDelegate,LeavesViewDataSource,TapDetectingImageViewDelegate> {
    NSString * mangaName;
	NSMutableArray * fileArray;
	BOOL statusBarHidden;
}

@property (nonatomic, retain) NSString * mangaName;
@property (nonatomic, retain) NSMutableArray * fileArray;

- (void)gotDoubleTap;

@end
