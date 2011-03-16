//
//  ReadMangaViewController.h
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MangaDetailView.h"

@interface ReadMangaViewController : UIViewController {
    NSThread * zipThread;
    NSThread * readmeThread;
    
    BOOL readMePanelActive;
    NSString * mangaName;
    NSString * readmeString;
    IBOutlet UIProgressView *zipProgressView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *ReadMangaButton;
    IBOutlet UILabel *loadingLabel;
    IBOutlet MangaDetailView *mainDetailView;
    IBOutlet UIView *OptionView;
    IBOutlet UIView *ReadMeView;
    IBOutlet UITextView *readMeDetailView;
}

@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *ReadMangaButton;
@property (nonatomic, retain) IBOutlet UITextView *readMeDetailView;
@property (nonatomic, retain) IBOutlet UIProgressView *zipProgressView;

- (void)setMangaName:(NSString*)newName;
- (void)scanZipForTextFile:(NSString*)zipName;
- (void)extractImagesFromZip:(NSString*)zipName;
- (void)createFileWithData:(NSData*)data atPath:(NSString*)filePath;
- (void)createDirWithTargetPathComponents:(NSArray*)targetPathComponents withMangaDir:(NSString*)mangaDir;
- (IBAction)showReadMe;
- (IBAction)dismissReadMePanel;

@end
