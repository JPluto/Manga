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

    NSString * mangaName;
	
	//Info panel
    IBOutlet UIImageView *previewPic;
    IBOutlet UIProgressView *zipProgressView;
    IBOutlet UILabel *titleLabel;
    IBOutlet UIButton *ReadMangaButton;
    IBOutlet UILabel *loadingLabel;
    IBOutlet MangaDetailView *mainDetailView;
    IBOutlet UIView *OptionView;
	
	//Readme panel
    IBOutlet UIView *ReadMeView;
    IBOutlet UITextView *readMeDetailView;
    BOOL readMePanelActive;
    NSString * readmeString;
    
    //Screenshot previews
    IBOutlet UIPageControl *screenshotPreviewPageControl;
    IBOutlet UIScrollView *screenshotPreviewScrollView;
    NSMutableArray *viewControllers;
    BOOL pageControlUsed;
    int kNumberOfPages;
    
    NSMutableArray * filearray;
}

//Properties
@property (nonatomic, retain) NSString * mangaName;

//Info panel
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *ReadMangaButton;
@property (nonatomic, retain) IBOutlet UIProgressView *zipProgressView;
@property (nonatomic, retain) IBOutlet UIImageView *previewPic;

//Readme panel
@property (nonatomic, retain) IBOutlet UITextView *readMeDetailView;
@property (nonatomic) BOOL readMePanelActive;

//Screenshot previews
@property (nonatomic, retain) IBOutlet UIPageControl *screenshotPreviewPageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *screenshotPreviewScrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;

//TODO: move this to FileUtils
- (void)extractImagesFromZip:(NSString*)zipName;

//Info panel
-(void)loadingProgress:(NSNumber *)nProgress;

//Readme actions
- (IBAction)toggleReadMe;
- (IBAction)showReadMe;
- (IBAction)dismissReadMePanel;

//Screenshot page control action
- (IBAction)changePage:(id)sender;

@end
