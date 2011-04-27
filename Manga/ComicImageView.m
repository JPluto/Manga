//
//  ComicImageView.m
//

#import "ComicImageView.h"


@interface ComicImageView ()
- (void)handleSingleTapAtPoint: (CGPoint) tapLocation;
- (void)handleDoubleTapAtPoint: (CGPoint) tapLocation;
- (void)handleTwoFingerTapAtPoint: (CGPoint) tapLocation;
@end

@implementation ComicImageView
//- (IBAction) NextPage;
@synthesize delegate;

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
	
	NSSet *allTouches = [event allTouches];
	UITouch *touch = [[allTouches allObjects] objectAtIndex:0];
	
	//NSLog(@"Touch: %f", [touch locationInView:self].x);
	switch ([allTouches count])
	{
		case 1:
		{
			CGPoint tapPoint = [touch locationInView:[UIApplication sharedApplication].keyWindow];
			//Get the first touch.
			
			switch([touch tapCount])
			{
				case 1://Single tap
					
					//[self handleSingleTapAtPoint: tapPoint];
					NSLog(@"SingleTap");
					break;
				case 2://Double tap.
					if ((tapPoint.y > 100.0f) && (tapPoint.y < 380.0f)) {
						[self handleDoubleTapAtPoint: [touch locationInView:self]];
						NSLog(@"DoubleTap");
					}
					break;
			}
			break;
		}
		case 2:
		{
			//Get the first touch.
			
			switch([touch tapCount])
			{
				case 2://Double tap.
					//[self handleTwoFingerTapAtPoint: [touch locationInView:self]];
					NSLog(@"TwoFingerTap");
					break;
			}
			break;
		}
			break;
	}
	
	
}

- (BOOL)canBecomeFirstResponder { 
	return YES; 
}

#pragma mark Private

- (void)handleSingleTapAtPoint: (CGPoint) tapLocation {
    if ([delegate respondsToSelector:@selector(tapDetectingImageView:gotSingleTapAtWindowPoint:)])
        [delegate tapDetectingImageView:self gotSingleTapAtWindowPoint:tapLocation];
}

- (void)handleDoubleTapAtPoint: (CGPoint) tapLocation  {
    if ([delegate respondsToSelector:@selector(tapDetectingImageView:gotDoubleTapAtPoint:)])
        [delegate tapDetectingImageView:self gotDoubleTapAtPoint:tapLocation];
}

- (void)handleTwoFingerTapAtPoint: (CGPoint) tapLocation  {
    if ([delegate respondsToSelector:@selector(tapDetectingImageView:gotTwoFingerTapAtPoint:)])
        [delegate tapDetectingImageView:self gotTwoFingerTapAtPoint:tapLocation];
}
@end
