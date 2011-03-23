//
//  PreviewViewController.m
//  Manga
//
//  Created by Hidde Jansen on 21-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import "PreviewViewController.h"


@implementation PreviewViewController

@synthesize previewImage;


- (id)initWithPageNumber:(int)page
{
    if ((self = [super initWithNibName:@"PreviewViewController" bundle:nil]))
    {
        pageNumber = page;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [previewImage release];
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
