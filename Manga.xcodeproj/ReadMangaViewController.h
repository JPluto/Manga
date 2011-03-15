//
//  ReadMangaViewController.h
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadMangaViewController : UIViewController {
    NSThread * readmeThread;
    
    NSString * mangaName;
    NSString * readmeString;
    IBOutlet UILabel *titleLabel;
    IBOutlet UILabel *infoBox;
    IBOutlet UIButton *readMeButton;
}

@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UILabel *infoBox;
@property (nonatomic, retain) IBOutlet UIButton *readMeButton;

- (void)setMangaName:(NSString*)newName;
- (void)scanZipForTextFile:(NSString*)zipName;
- (IBAction)showReadMe:(id)sender;

@end
