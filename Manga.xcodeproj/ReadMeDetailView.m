//
//  ReadMeDetailView.m
//  Manga
//
//  Created by Hidde Jansen on 21-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ReadMeDetailView.h"
#import <QuartzCore/QuartzCore.h>

@implementation ReadMeDetailView

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
    // Drawing code
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
