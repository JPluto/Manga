//
//  MangaInfoViewController.m
//  Manga
//
//  Created by Hidde Jansen on 21-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MangaInfoScrollViewController.h"

@implementation MangaInfoScrollViewController

@synthesize mangaName;


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

#pragma mark - View lifecycle

- (void)viewWillAppear:(BOOL)animated {
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
        zipThread= [[NSThread alloc] initWithTarget:detailViewController selector:@selector(extractImagesFromZip:) object:zipFilePath];
        [zipThread start];
    }
    else
    {
        [detailViewController.readMeDetailView setText:[detailViewController scanMangaDirForReadMe:mangaDirectory]];
        [detailViewController.loadingLabel setText:@"Manga loaded"];
        [detailViewController.ReadMangaButton setEnabled:YES];
        [detailViewController.zipProgressView setHidden:YES];
        [detailViewController scanMangaDirForPreviewPic: mangaDirectory];
    }
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
