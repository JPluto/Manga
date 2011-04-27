//
//  MangaViewController.m
//  Manga
//
//  Created by Hidde Jansen on 29-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MangaViewController.h"

@implementation MangaViewController

@synthesize mangaName;
@synthesize fileArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
		statusBarHidden = YES;
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSSet *allTouches = [event allTouches];
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
			
	switch([touch tapCount])
	{
		case 1://Single tap
			//[self handleSingleTapAtPoint: tapPoint];
			NSLog(@"SingleTap");
		break;
		case 2://Double tap.
			[self gotDoubleTap];
			NSLog(@"DoubleTap");
		break;
	}
}

#pragma mark - View lifecycle

- (NSUInteger) numberOfPagesInLeavesView:(LeavesView*)leavesView {
    return [fileArray count];
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
	UIImage *image = [UIImage imageWithContentsOfFile:[fileArray objectAtIndex:index]];
	CGRect imageRect = CGRectMake(0, 0, image.size.width, image.size.height);
	CGAffineTransform transform = aspectFit(imageRect,CGContextGetClipBoundingBox(ctx));
	CGContextConcatCTM(ctx, transform);
	CGContextDrawImage(ctx, imageRect, [image CGImage]);
}

- (void)gotDoubleTap {
	[[UIApplication sharedApplication] setStatusBarHidden:!statusBarHidden withAnimation:UIStatusBarAnimationSlide];
	statusBarHidden = !statusBarHidden;
	[self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[self.navigationController setNavigationBarHidden:YES animated:YES];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
