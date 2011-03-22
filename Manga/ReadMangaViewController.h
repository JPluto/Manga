//
//  ReadMangaViewController.h
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MangaDetailView.h"

@interface ReadMangaViewController : UIViewController <UIScrollViewDelegate> {
    NSThread * readmeThread;
    
    BOOL readMePanelActive;
    NSString * mangaName;
    NSString * readmeString;
    IBOutlet UIImageView *previewPic;
    IBOutlet UIProgressView *zipProgressView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *ReadMangaButton;
    IBOutlet UILabel *loadingLabel;
    IBOutlet MangaDetailView *mainDetailView;
    IBOutlet UIView *OptionView;
    IBOutlet UIView *ReadMeView;
    IBOutlet UITextView *readMeDetailView;
    
    //Screenshot Preview
    IBOutlet UIPageControl *screenshotPreviewPageControl;
    IBOutlet UIScrollView *screenshotPreviewScrollView;
    NSMutableArray *viewControllers;
    
    NSMutableArray * filearray;
    
    // To be used when scrolls originate from the UIPageControl
    BOOL pageControlUsed;
    
    int kNumberOfPages;
}

@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *ReadMangaButton;
@property (nonatomic, retain) IBOutlet UITextView *readMeDetailView;
@property (nonatomic, retain) IBOutlet UIProgressView *zipProgressView;
@property (nonatomic) BOOL readMePanelActive;


@property (nonatomic, retain) IBOutlet UIPageControl *screenshotPreviewPageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *screenshotPreviewScrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (void)setMangaName:(NSString*)newName;
//- (void)scanZipForTextFile:(NSString*)zipName;
- (NSString*)scanMangaDirForReadMe:(NSString*)mangaDir;
- (void)scanMangaDirForPreviewPic:(NSString*)mangaDir;
- (void)extractImagesFromZip:(NSString*)zipName;
- (void)createFileWithData:(NSData*)data atPath:(NSString*)filePath;
- (void)createDirWithTargetPathComponents:(NSArray*)targetPathComponents withMangaDir:(NSString*)mangaDir;
- (IBAction)showReadMe;
- (IBAction)dismissReadMePanel;

- (IBAction)changePage:(id)sender;

@end
