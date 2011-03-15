//
//  FileUtils.m
//  Manga
//
//  Created by Hidde Jansen on 13-03-11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FileUtils.h"


@implementation FileUtils

+(NSMutableArray*)listFiles{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDirectoryEnumerator *directoryEnumerator = [[NSFileManager defaultManager] enumeratorAtPath:documentsDirectory];
    NSMutableArray * ComicFileList = [[NSMutableArray alloc] init];
    
    NSLog(@"Start listing");
    
    for (NSString *path in directoryEnumerator) 
    {
        if ([[path pathExtension] isEqualToString:@"zip"] ) 
        { 
            [ComicFileList addObject:path];  
            NSLog(@"%@", path);
        }
    }
    
    NSLog(@"Stop listing");
    
    return ComicFileList;
}

@end
