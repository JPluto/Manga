//
//  MangaInfoViewController.h
//  Manga
//
//  Created by Hidde Jansen on 21-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ReadMangaViewController.h"


@interface MangaInfoScrollViewController : UIViewController {
    
    NSString * mangaName;
    
    NSThread * zipThread;
    
    ReadMangaViewController *detailViewController;
}

@property (nonatomic, retain) NSString * mangaName;

@end
