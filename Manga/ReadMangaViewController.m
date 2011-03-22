//
//  ReadMangaViewController.m
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 

#import "ReadMangaViewController.h"
#import "PreviewViewController.h"

#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"


@interface ReadMangaViewController (PrivateMethods)
- (void)loadScrollViewWithPage:(int)page;
- (void)scrollViewDidScroll:(UIScrollView *)sender;

+ (UIImage*)imageWithImage:(UIImage*)image ;
@end

@implementation ReadMangaViewController

@synthesize loadingLabel;
@synthesize titleLabel;
@synthesize ReadMangaButton;
@synthesize readMeDetailView;
@synthesize zipProgressView;
@synthesize readMePanelActive;

@synthesize screenshotPreviewScrollView;
@synthesize screenshotPreviewPageControl;
@synthesize viewControllers;

+ (UIImage*)imageWithImage:(UIImage*)image;
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 217/254.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 254.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 254.0;
        }
        else{
            imgRatio = 217.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 217.0;
        }
    }
    UIGraphicsBeginImageContext( CGSizeMake(actualWidth, actualHeight) );
    [image drawInRect:CGRectMake(0,0,actualWidth,actualHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        kNumberOfPages = 3;
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)setMangaName:(NSString*)newName {
    mangaName = newName;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setTitle:mangaName];
    [titleLabel setText:[[mangaName lastPathComponent] stringByDeletingPathExtension]];
    
//    ReadMeView.layer.shadowColor = [[UIColor blackColor] CGColor];
//    ReadMeView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    ReadMeView.layer.shadowOpacity = 0.5;
//    ReadMeView.layer.shadowRadius = 10;
    
    readMePanelActive = YES;
    [self showReadMe];

    // view controllers are created lazily
    // in the meantime, load the array with placeholders which will be replaced on demand
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (unsigned i = 0; i < kNumberOfPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.viewControllers = controllers;
    [controllers release];
    
    // a page is the width of the scroll view
    screenshotPreviewScrollView.pagingEnabled = YES;
    screenshotPreviewScrollView.contentSize = CGSizeMake(screenshotPreviewScrollView.frame.size.width * kNumberOfPages, screenshotPreviewScrollView.frame.size.height);
    screenshotPreviewScrollView.showsHorizontalScrollIndicator = NO;
    screenshotPreviewScrollView.showsVerticalScrollIndicator = NO;
    screenshotPreviewScrollView.scrollsToTop = NO;
    screenshotPreviewScrollView.delegate = self;
    
    screenshotPreviewPageControl.numberOfPages = kNumberOfPages;
    screenshotPreviewPageControl.currentPage = 0;
    
    // pages are created on demand
    // load the visible page
    // load the page on either side to avoid flashes when the user starts scrolling
    //
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    CGRect frame = screenshotPreviewScrollView.frame;
    frame.origin.x = frame.size.width;
    frame.origin.y = 0;
    [screenshotPreviewScrollView scrollRectToVisible:frame animated:YES];
}

- (NSString*)scanMangaDirForReadMe:(NSString*)mangaDir {
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    NSString *file;
    // Get all of the files in the source directory, loop thru them.
    NSEnumerator *files = [filemanager enumeratorAtPath:mangaDir];
    while((file = [files nextObject]) ) {
        if( [[file pathExtension] isEqualToString:@"txt"] )
        {
            NSString * textfiledir = [mangaDir stringByAppendingPathComponent:file];
            NSData * data = [filemanager contentsAtPath:textfiledir];
            NSString * textfile = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            return textfile;
        }
        //NSLog(@"%@", file);
    }
        
    return @"File contains no additional information.";
}

- (void)scanMangaDirForPreviewPic:(NSString*)mangaDir {
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    NSString *file;
    mangaDir = [mangaDir stringByAppendingPathComponent:@"previews"];
    // Get all of the files in the source directory, loop thru them.
    NSEnumerator *files = [filemanager enumeratorAtPath:mangaDir];
    while((file = [files nextObject]) ) {
        if( [[file pathExtension] isEqualToString:@"jpg"] )
        {
            NSString * previewPicDir = [mangaDir stringByAppendingPathComponent:file];
            [previewPic setImage: [UIImage imageWithContentsOfFile:previewPicDir]];
            break;
        }
        //NSLog(@"%@", file);
    }
}

/*
- (void)scanZipForTextFile:(NSString*)zipName{
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
    
    ZipFile *unzipFile= [[ZipFile alloc] initWithFileName:zipName mode:ZipFileModeUnzip];
    NSArray *infos= [unzipFile listFileInZipInfos];
    for (FileInZipInfo *info in infos) {
        //NSLog(@"- %@ %@ %d (%d)", info.name, info.date, info.size, info.level);
        
        // Locate the file in the zip
        [unzipFile locateFileInZip:info.name];
        
    }
    [unzipFile close];
    [unzipFile release];
    
	[pool drain];
}
*/
- (void)extractImagesFromZip:(NSString*)zipName {
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
    
    ZipFile *unzipFile= [[ZipFile alloc] initWithFileName:zipName mode:ZipFileModeUnzip];
    NSArray *infos= [unzipFile listFileInZipInfos];
    
    int count = 0;
    float progress = 0;
    [zipProgressView setProgress:progress];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cacheDirectory = [paths objectAtIndex:0];
    NSString * mangaCleanName = [mangaName stringByDeletingPathExtension];
    NSString * mangaDirectory = [cacheDirectory stringByAppendingPathComponent:mangaCleanName];
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    //Dir does not exist: create it
    BOOL isDir;
    if(![filemanager fileExistsAtPath:mangaDirectory isDirectory:&isDir] || !isDir)
    {
        [filemanager createDirectoryAtPath:mangaDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
        [filemanager createDirectoryAtPath:[mangaDirectory stringByAppendingPathComponent:@"previews"] withIntermediateDirectories:NO attributes:nil error:NULL];
        
        for (FileInZipInfo *info in infos) {
            //NSLog(@"- %@ %@ %d (%d)", info.name, info.date, info.size, info.level);
            
            // Locate the file in the zip
            [unzipFile locateFileInZip:info.name];
            
            
            if([info.name hasSuffix:@".jpg"] || [info.name hasSuffix:@".JPG"] || [info.name hasSuffix:@".PNG"] || [info.name hasSuffix:@".png"] || [info.name hasSuffix:@".GIF"] || [info.name hasSuffix:@".gif"])
            {
                
                NSLog(@"%@ == image file", info.name);
                
                NSMutableArray * targetPathComponents = [NSMutableArray arrayWithCapacity:[[info.name pathComponents] count]];
                [targetPathComponents addObjectsFromArray:[info.name pathComponents]];
                [targetPathComponents removeLastObject];
                
                if([targetPathComponents count] >= 1)
                {
                    [self createDirWithTargetPathComponents:targetPathComponents withMangaDir:mangaDirectory];
                }
                
                // Expand the file in memory
                ZipReadStream *read= [unzipFile readCurrentFileInZip];
                NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
                int bytesRead= [read readDataWithBuffer:data];
                [read finishedReading];
                
                NSString * theTargetDir = [mangaDirectory stringByAppendingPathComponent:info.name];
                
                [self createFileWithData:data atPath:theTargetDir];
                
                if(count == 0)
                {
                    if([[info.name pathExtension] isEqualToString:@"jpg"])
                    {
                        NSData *filedata = UIImageJPEGRepresentation([ReadMangaViewController imageWithImage:[UIImage imageWithData:data]], 0.9);
                        [self createFileWithData:filedata atPath:[[mangaDirectory stringByAppendingPathComponent:@"previews"] stringByAppendingPathComponent: [info.name lastPathComponent]]];
                    }
                    else if([[info.name pathExtension] isEqualToString:@"png"])
                    {
                        NSData *filedata = UIImagePNGRepresentation([ReadMangaViewController imageWithImage:[UIImage imageWithData:data]]);
                        [self createFileWithData:filedata atPath:[[mangaDirectory stringByAppendingPathComponent:@"previews"] stringByAppendingPathComponent: [info.name lastPathComponent]]];
                    }
                }
                else if (count == 1)
                {
                    if([[info.name pathExtension] isEqualToString:@"jpg"])
                    {
                        NSData *filedata = UIImageJPEGRepresentation([ReadMangaViewController imageWithImage:[UIImage imageWithData:data]], 0.9);
                        [self createFileWithData:filedata atPath:[[mangaDirectory stringByAppendingPathComponent:@"previews"] stringByAppendingPathComponent: [info.name lastPathComponent]]];
                    }
                    else if([[info.name pathExtension] isEqualToString:@"png"])
                    {
                        NSData *filedata = UIImagePNGRepresentation([ReadMangaViewController imageWithImage:[UIImage imageWithData:data]]);
                        [self createFileWithData:filedata atPath:[[mangaDirectory stringByAppendingPathComponent:@"previews"] stringByAppendingPathComponent: [info.name lastPathComponent]]];
                    }
                }
                else if (count == 2)
                {
                    if([[info.name pathExtension] isEqualToString:@"jpg"])
                    {
                        NSData *filedata = UIImageJPEGRepresentation([ReadMangaViewController imageWithImage:[UIImage imageWithData:data]], 0.9);
                        [self createFileWithData:filedata atPath:[[mangaDirectory stringByAppendingPathComponent:@"previews"] stringByAppendingPathComponent: [info.name lastPathComponent]]];
                    }
                    else if([[info.name pathExtension] isEqualToString:@"png"])
                    {
                        NSData *filedata = UIImagePNGRepresentation([ReadMangaViewController imageWithImage:[UIImage imageWithData:data]]);
                        [self createFileWithData:filedata atPath:[[mangaDirectory stringByAppendingPathComponent:@"previews"] stringByAppendingPathComponent: [info.name lastPathComponent]]];
                    }
                }
                
                //Update Progress
                count++;
                progress = (float) count / [infos count];
                [self performSelectorOnMainThread:@selector(loadingProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:NO];
                [zipProgressView setProgress:progress];
                NSLog(@"Progress %f", progress);
                
                targetPathComponents = nil;
            }
            
            if([info.name hasSuffix:@".txt"] || [info.name hasSuffix:@".TXT"])
            {
                NSLog(@"%@ == text file", info.name);
                NSMutableArray * targetPathComponents = [NSMutableArray arrayWithCapacity:[[info.name pathComponents] count]];
                [targetPathComponents addObjectsFromArray:[info.name pathComponents]];
                [targetPathComponents removeLastObject];
                
                if([targetPathComponents count] >= 1)
                {
                    [self createDirWithTargetPathComponents:targetPathComponents withMangaDir:mangaDirectory];
                }
                
                // Expand the file in memory
                ZipReadStream *read= [unzipFile readCurrentFileInZip];
                NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
                int bytesRead= [read readDataWithBuffer:data];
                [read finishedReading];
                
                //Set the info's on the screen
                readmeString = [[[NSString alloc] initWithBytes:[data bytes] length:bytesRead encoding:NSUTF8StringEncoding] autorelease];
                [readMeDetailView performSelectorOnMainThread:@selector(setText:) withObject:readmeString waitUntilDone:NO];
                
                //Save the file
                NSString * theTargetDir = [mangaDirectory stringByAppendingPathComponent:info.name];
                [self createFileWithData:data atPath:theTargetDir];

                targetPathComponents = nil;
            }
        }
        [zipProgressView setProgress:1];
    }
    
    [unzipFile close];
    [unzipFile release];
    
    
    [loadingLabel setText:@"Manga loaded"];
    [ReadMangaButton setEnabled:YES];
    [zipProgressView setHidden:YES];
    [self scanMangaDirForPreviewPic: mangaDirectory];
    
    int page = screenshotPreviewPageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	[pool drain];
}
- (void)createFileWithData:(NSData*)data atPath:(NSString*)filePath {
    NSFileManager * filemanager = [NSFileManager defaultManager];

    if(![filemanager fileExistsAtPath:filePath])
    {
        [filemanager createFileAtPath:filePath contents:data attributes: nil];
    }
    
}
-(void)createDirWithTargetPathComponents:(NSArray*)targetPathComponents withMangaDir:(NSString*)mangaDir{
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    NSString * filePath = mangaDir;
    
    for (NSString * component in targetPathComponents)
    {
        filePath = [filePath stringByAppendingPathComponent:component];
       
        //Dir does not exist: create it
        BOOL isDir = NO;
        if(![filemanager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
        {
            [filemanager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:NULL];
        }
    }
    
}

- (IBAction)toggleReadMe {
    if (readMePanelActive == YES)
    {
        readMePanelActive = NO;
        [self dismissReadMePanel];
    }
    else
    {
        readMePanelActive = YES;
        [self showReadMe];
        
    }
}

- (void)showReadMe {
    CGRect viewFrame = [OptionView frame];
    viewFrame.origin.y = 600;
    ReadMeView.frame = viewFrame;
    
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.5];
    
    CGRect viewFrame2 = [OptionView frame];
    viewFrame2.origin.y = viewFrame2.origin.y + 40;
    
    ReadMeView.frame = viewFrame2;
    
    [self.view addSubview:ReadMeView];
    [UIView commitAnimations];
}

- (void)dismissReadMePanel {
    [UIView beginAnimations:@"animateView" context:nil];
    [UIView setAnimationDuration:0.5];
    
    CGRect viewFrame = [OptionView frame];
    viewFrame.origin.y = 600;
    ReadMeView.frame = viewFrame;
    
    [self.view addSubview:ReadMeView];
    [UIView commitAnimations];
}

-(void)loadingProgress:(NSNumber *)nProgress{
    float progress = [nProgress floatValue];
    NSLog(@"Progress %f", progress);
    zipProgressView.progress = progress;
}

- (void)viewDidUnload
{
    [titleLabel release];
    [OptionView release];
    [ReadMeView release];
    [readMeDetailView release];
    [mainDetailView release];
    [zipProgressView release];
    [loadingLabel release];
    [ReadMangaButton release];
    [previewPic release];
    [screenshotPreviewPageControl release];
    [screenshotPreviewScrollView release];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark Preview Scroll methods
- (void)loadScrollViewWithPage:(int)page
{
    if (page < 0)
        return;
    if (page >= kNumberOfPages)
        return;
    
    // replace the placeholder if necessary
    PreviewViewController *controller = [viewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[PreviewViewController alloc] initWithPageNumber:page];
        [viewControllers replaceObjectAtIndex:page withObject:controller];
        [controller release];
    }
    
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cacheDirectory = [paths objectAtIndex:0];
    NSString * mangaCleanName = [mangaName stringByDeletingPathExtension];
    NSString * mangaDirectory = [[cacheDirectory stringByAppendingPathComponent:mangaCleanName] stringByAppendingPathComponent:@"previews"];
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    NSString * previewPicDir;
    NSString *file;
    int count = 0;
    [controller.previewImage setImage:[UIImage imageNamed:@"loading"]];
    
    // Get all of the files in the source directory, loop thru them.
    NSEnumerator *files = [filemanager enumeratorAtPath:mangaDirectory];
    while((file = [files nextObject]) ) {
        if( [[file pathExtension] isEqualToString:@"jpg"] || [[file pathExtension] isEqualToString:@"gif"] || [[file pathExtension] isEqualToString:@"png"] )
        {
            if( page == 0 && count == 0)
            {
                previewPicDir = [mangaDirectory stringByAppendingPathComponent:file];
                [controller.previewImage setImage: [UIImage imageWithContentsOfFile:previewPicDir]];
                NSLog(@"Page 1: %@", previewPicDir);
            }
            if( page == 1 && count == 1)
            {
                previewPicDir = [mangaDirectory stringByAppendingPathComponent:file];
                [controller.previewImage setImage: [UIImage imageWithContentsOfFile:previewPicDir]];
                NSLog(@"Page 2: %@", previewPicDir);
            }
            if( page == 2 && count == 2)
            {
                previewPicDir = [mangaDirectory stringByAppendingPathComponent:file];
                [controller.previewImage setImage: [UIImage imageWithContentsOfFile:previewPicDir]];
                NSLog(@"Page 3: %@", previewPicDir);
            }
            count++;
        }
        //NSLog(@"%@", file);
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil)
    {
        CGRect frame = screenshotPreviewScrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [screenshotPreviewScrollView addSubview:controller.view];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (pageControlUsed)
    {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
	
    // Switch the indicator when more than 50% of the previous/next page is visible
    CGFloat pageWidth = screenshotPreviewScrollView.frame.size.width;
    int page = floor((screenshotPreviewScrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    screenshotPreviewPageControl.currentPage = page;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // A possible optimization would be to unload the views+controllers which are no longer visible
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    pageControlUsed = NO;
}

- (IBAction)changePage:(id)sender
{
    int page = screenshotPreviewPageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
	// update the scroll view to the appropriate page
    CGRect frame = screenshotPreviewScrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    [screenshotPreviewScrollView scrollRectToVisible:frame animated:YES];
    
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    pageControlUsed = YES;
}

@end
