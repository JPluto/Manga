//
//  ReadMangaViewController.m
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h> 

#import "ReadMangaViewController.h"


#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"

@implementation ReadMangaViewController

@synthesize loadingLabel;
@synthesize titleLabel;
@synthesize ReadMangaButton;
@synthesize readMeDetailView;
@synthesize zipProgressView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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

-(void)viewDidAppear:(BOOL)animated {
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsPaths objectAtIndex:0];
    NSString * zipFilePath = [documentsDirectory stringByAppendingPathComponent:mangaName];
    
    NSArray * cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cacheDirectory = [cachePaths objectAtIndex:0];
    NSString * mangaDirectory = [cacheDirectory stringByAppendingPathComponent:[mangaName stringByDeletingPathExtension]];
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    //Manga cache directory does not exist: proceed by creating and extracting
    BOOL isDir;
    if(![filemanager fileExistsAtPath:mangaDirectory isDirectory:&isDir] || !isDir)
    {
        zipThread= [[NSThread alloc] initWithTarget:self selector:@selector(extractImagesFromZip:) object:zipFilePath];
        [zipThread start];
    }
    else
    {
        [readMeDetailView setText:[self scanMangaDirForReadMe:mangaDirectory]];
        [loadingLabel setText:@"Manga loaded"];
        [ReadMangaButton setEnabled:YES];
        [zipProgressView setHidden:YES];
    }
    
    
    /*
    readmeThread= [[NSThread alloc] initWithTarget:self selector:@selector(scanZipForTextFile:) object:filePath];
	[readmeThread start];*/
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setTitle:mangaName];
    [titleLabel setText:[[mangaName lastPathComponent] stringByDeletingPathExtension]];
    
    mainDetailView.layer.shadowColor = [[UIColor blackColor] CGColor];
    mainDetailView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    mainDetailView.layer.shadowOpacity = 1.0;
    mainDetailView.layer.shadowRadius = 10;
    
    ReadMeView.layer.shadowColor = [[UIColor blackColor] CGColor];
    ReadMeView.layer.shadowOffset = CGSizeMake(0.0, 0.0);
    ReadMeView.layer.shadowOpacity = 1.0;
    ReadMeView.layer.shadowRadius = 10;
}


- (NSString*)scanMangaDirForReadMe:(NSString*)mangaDir {
    
    return @"File contains no additional information.";
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
    viewFrame.origin.y = 480;
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
    viewFrame.origin.y = 480;
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
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
