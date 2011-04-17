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

@protocol DetailViewControllerDelegate;

@interface ReadMangaViewController : UIViewController <UIScrollViewDelegate> {
	id <DetailViewControllerDelegate> delegate;
	
    NSThread * readmeThread;

    NSString * mangaName;
    NSString * zipPath;
	
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
}

@property (nonatomic, assign) id <DetailViewControllerDelegate> delegate;

//Properties
@property (nonatomic, retain) NSString * mangaName;
@property (nonatomic, retain) NSString * zipPath;

//Info panel
@property (nonatomic, retain) IBOutlet UILabel *loadingLabel;
@property (nonatomic, retain) IBOutlet UILabel *titleLabel;
@property (nonatomic, retain) IBOutlet UIButton *ReadMangaButton;
@property (nonatomic, retain) IBOutlet UIProgressView *zipProgressView;
@property (nonatomic, retain) IBOutlet UIImageView *previewPic;

//Readme panel
@property (nonatomic, retain) IBOutlet UITextView *readMeDetailView;
@property (nonatomic) BOOL readMePanelActive;
@property (nonatomic, retain) NSString * readmeString;

//Screenshot previews
@property (nonatomic, retain) IBOutlet UIPageControl *screenshotPreviewPageControl;
@property (nonatomic, retain) IBOutlet UIScrollView *screenshotPreviewScrollView;
@property (nonatomic, retain) NSMutableArray *viewControllers;

-(IBAction)touchReadMangaButton:(id)sender;

//Info panel
-(void)loadingProgress:(NSNumber *)nProgress;

//Readme actions
- (IBAction)toggleReadMe;
- (IBAction)showReadMe;
- (IBAction)dismissReadMePanel;

//Screenshot page control action
- (IBAction)changePage:(id)sender;
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

@end


@protocol DetailViewControllerDelegate 

@property (nonatomic, retain) NSMutableArray * filearray;

- (void)DetailViewControllerReadTouched:(ReadMangaViewController *)controller;
@end

