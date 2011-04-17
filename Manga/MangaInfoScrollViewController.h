//
//  MangaInfoViewController.h
//  Manga
//
//  Created by Hidde Jansen on 21-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ReadMangaViewController.h"

#import "FileUtils.h"


@interface MangaInfoScrollViewController : UIViewController<DetailViewControllerDelegate> {
    
    NSString * mangaName;
    
    NSThread * zipThread;
    
    ReadMangaViewController *detailViewController;
}

@property (nonatomic, retain) NSString * mangaName;

- (void)DetailViewControllerReadTouched:(ReadMangaViewController *)controller;

@end
