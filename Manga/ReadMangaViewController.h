//
//  ReadMangaViewController.h
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "MangaDetailView.h"
#import "PreviewViewController.h"

#import "FileUtils.h"

#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"

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
    BOOL pageControlUsed;
    int kNumberOfPages;
    
    NSMutableArray * filearray;
}

@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *ReadMangaButton;
@property (nonatomic, retain) IBOutlet UITextView *readMeDetailView;
@property (nonatomic, retain) IBOutlet UIProgressView *zipProgressView;
@property (nonatomic) BOOL readMePanelActive;

@property (nonatomic, retain) IBOutlet UIImageView *previewPic;

@property (nonatomic, retain) IBOutlet UIPageControl *screenshotPreviewPageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *screenshotPreviewScrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;

- (void)setMangaName:(NSString*)newName;

- (void)extractImagesFromZip:(NSString*)zipName;

- (IBAction)toggleReadMe;
- (IBAction)showReadMe;
- (IBAction)dismissReadMePanel;

- (IBAction)changePage:(id)sender;

@end
