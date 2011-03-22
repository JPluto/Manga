//
//  PreviewViewController.h
//  Manga
//
//  Created by Hidde Jansen on 21-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface PreviewViewController : UIViewController {
    
    IBOutlet UIImageView *previewImage;
    int pageNumber;
}


@property (nonatomic, retain) IBOutlet UIImageView *previewImage;

- (id)initWithPageNumber:(int)page;

@end
