//
//  ReadMeViewController.h
//  Manga
//
//  Created by Hidde Jansen on 15-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ReadMeViewController : UIViewController {
    IBOutlet UITextView *readMeTextView;
}

@property (nonatomic, retain) IBOutlet UITextView *readMeTextView;

@end
