//
//  ReadMangaViewController.m
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReadMangaViewController.h"
#import "ReadMeViewController.h"
#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"

@implementation ReadMangaViewController

@synthesize titleLabel;
@synthesize infoBox;
@synthesize readMeButton;

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
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString * filePath = [documentsDirectory stringByAppendingPathComponent:mangaName];
    
    readmeThread= [[NSThread alloc] initWithTarget:self selector:@selector(scanZipForTextFile:) object:filePath];
	[readmeThread start];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [[self navigationController] setTitle:mangaName];
    [titleLabel setText:[[mangaName lastPathComponent] stringByDeletingPathExtension]];
}

- (void)scanZipForTextFile:(NSString*)zipName{
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
    
    ZipFile *unzipFile= [[ZipFile alloc] initWithFileName:zipName mode:ZipFileModeUnzip];
    NSArray *infos= [unzipFile listFileInZipInfos];
    for (FileInZipInfo *info in infos) {
        //NSLog(@"- %@ %@ %d (%d)", info.name, info.date, info.size, info.level);
        
        // Locate the file in the zip
        [unzipFile locateFileInZip:info.name];
        
        
        if([info.name hasSuffix:@".txt"] || [info.name hasSuffix:@".TXT"])
        {
            NSLog(@"%@ == text file", info.name);
            // Expand the file in memory
            ZipReadStream *read= [unzipFile readCurrentFileInZip];
            NSMutableData *data= [[NSMutableData alloc] initWithLength:256];
            int bytesRead= [read readDataWithBuffer:data];
            [read finishedReading];
            readmeString = [[[NSString alloc] initWithBytes:[data bytes] length:bytesRead encoding:NSUTF8StringEncoding] autorelease];
            [infoBox setText:readmeString];
            [readMeButton setEnabled:YES];
        }
    }
    [unzipFile close];
    [unzipFile release];
    
	[pool drain];
}

- (IBAction)showReadMe:(id)sender {
    ReadMeViewController *readMeView = [[ReadMeViewController alloc] init];
    readMeView.readMeTextView.text = readmeString;
    [self.navigationController pushViewController:readMeView animated:YES];
    [readMeView release];
}

- (void)viewDidUnload
{
    [titleLabel release];
    [infoBox release];
    [readMeButton release];
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
