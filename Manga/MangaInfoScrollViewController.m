//
//  MangaInfoViewController.m
//  Manga
//
//  Created by Hidde Jansen on 21-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import "MangaInfoScrollViewController.h"
#import "MangaViewController.h"
#import "FileUtils.h"
@implementation MangaInfoScrollViewController

@synthesize mangaName;
@synthesize filearray;

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

- (void)DetailViewControllerReadTouched:(ReadMangaViewController *)controller{
	MangaViewController * readView = [[[MangaViewController alloc] initWithNibName:@"MangaViewController" bundle:nil] autorelease];
	[readView setMangaName:mangaName];
	[readView setFileArray:filearray];
	[self.navigationController pushViewController:readView animated:YES];
}

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
    //Retrieve zip path
    NSArray *documentsPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [documentsPaths objectAtIndex:0];
    NSString * zipFilePath = [documentsDirectory stringByAppendingPathComponent:mangaName];
    
	detailViewController.zipPath = zipFilePath;
	
    //Retrieve cache path
    NSArray * cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cacheDirectory = [cachePaths objectAtIndex:0];
    NSString * mangaDirectory = [cacheDirectory stringByAppendingPathComponent:[mangaName stringByDeletingPathExtension]];
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    BOOL isDir;
	
    //Manga cache directory does not exist: proceed by creating and extracting
    if(![filemanager fileExistsAtPath:mangaDirectory isDirectory:&isDir] || !isDir)
    {
        zipThread= [[NSThread alloc] initWithTarget:[FileUtils class] selector:@selector(extractFilesFromZip:) object:detailViewController];
        [zipThread start];
    }
    else
    {
        [detailViewController.readMeDetailView setText:[FileUtils scanMangaDirForReadMe:mangaDirectory]];
        [detailViewController.loadingLabel setText:@"Manga loaded"];
        [detailViewController.ReadMangaButton setEnabled:YES];
        [detailViewController.zipProgressView setHidden:YES];
        [detailViewController.previewPic setImage: [FileUtils scanMangaDirForPreviewPic: mangaDirectory]];
		self.filearray = [FileUtils scanMangaDir:mangaDirectory];
    }
	self.navigationController.navigationBarHidden = NO;
}

-(void)viewWillDisappear:(BOOL)animated {
    
    if (detailViewController.readMePanelActive == YES) {
        [detailViewController dismissReadMePanel];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UIScrollView *tempScrollView = (UIScrollView *)self.view;
    tempScrollView.contentSize = CGSizeMake(320,572);
    
    
    detailViewController = [[ReadMangaViewController alloc] init];
	detailViewController.delegate = self;
    [detailViewController setMangaName:mangaName];
    [self.view addSubview: detailViewController.view];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
    [detailViewController release];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
