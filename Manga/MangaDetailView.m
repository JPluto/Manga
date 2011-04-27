//
//  MangaDetailView.m
//  Manga
//
//  Created by Hidde Jansen on 14-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "MangaDetailView.h"


@implementation MangaDetailView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    //Set shadow
/*    self.layer.shadowOpacity = 1.0;
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowRadius = 10;
*/
    //Gradient with border
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor], (id)[[UIColor lightGrayColor] CGColor], nil];
    gradient.borderColor = [UIColor darkGrayColor].CGColor;
    gradient.borderWidth = 1.0f;
    [self.layer insertSublayer:gradient atIndex:0];
    
}

- (void)dealloc
{
    [super dealloc];
}

@end
