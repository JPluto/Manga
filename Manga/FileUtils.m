//
//  FileUtils.m
//  Manga
//
//  Created by Hidde Jansen on 13-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import "FileUtils.h"


@implementation FileUtils

#pragma mark Image File Methods

+ (UIImage*)imageWithImage:(UIImage*)image;
{
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
    float maxRatio = 217/254.0;
    
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = 254.0 / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = 254.0;
        }
        else{
            imgRatio = 217.0 / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = 217.0;
        }
    }
    UIGraphicsBeginImageContext( CGSizeMake(actualWidth, actualHeight) );
    [image drawInRect:CGRectMake(0,0,actualWidth,actualHeight)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

#pragma mark Directory listing

+ (NSMutableArray*)listFiles{
    
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

#pragma mark Scan Directories

+ (NSString*)scanMangaDirForReadMe:(NSString*)mangaDir {
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    NSString *file;
    
    // Get all of the files in the source directory, loop through them.
    NSEnumerator *files = [filemanager enumeratorAtPath:mangaDir];
    while((file = [files nextObject]) ) {
        //We are looking for txt files only
        if( [[file pathExtension] isEqualToString:@"txt"] )
        {
            NSString * textfiledir = [mangaDir stringByAppendingPathComponent:file];
            NSData * data = [filemanager contentsAtPath:textfiledir];
            NSString * textfile = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
            return textfile;
        }
    }
    
    return @"File contains no additional information.";
}



+ (UIImage*)scanMangaDirForPreviewPic:(NSString*)mangaDir {
    
    //Previews directory
    mangaDir = [mangaDir stringByAppendingPathComponent:@"previews"];
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    NSString *file;
    
    //Get all of the files in the source directory, loop thru them.
    NSEnumerator *files = [filemanager enumeratorAtPath:mangaDir];
    while((file = [files nextObject]) ) {
        //Only looking for jpg
        if( [[file pathExtension] isEqualToString:@"jpg"] )
        {
            NSString * previewPicDir = [mangaDir stringByAppendingPathComponent:file];
            return [UIImage imageWithContentsOfFile:previewPicDir];
        }
    }
    
    //We have nothing so return nil
    return nil;
}

#pragma mark Creating files, folders

+ (void)createFileWithData:(NSData*)data atPath:(NSString*)filePath {
    NSFileManager * filemanager = [NSFileManager defaultManager];
	
    if(![filemanager fileExistsAtPath:filePath])
    {
        [filemanager createFileAtPath:filePath contents:data attributes: nil];
    }
    
}
+ (void)createDirWithTargetPathComponents:(NSArray*)targetPathComponents withMangaDir:(NSString*)mangaDir{
    
    NSFileManager * filemanager = [NSFileManager defaultManager];
    NSString * filePath = mangaDir;
    
    for (NSString * component in targetPathComponents)
    {
        filePath = [filePath stringByAppendingPathComponent:component];
		
        //Dir does not exist: create it
        BOOL isDir = NO;
        if(![filemanager fileExistsAtPath:filePath isDirectory:&isDir] && !isDir)
        {
            [filemanager createDirectoryAtPath:filePath withIntermediateDirectories:NO attributes:nil error:NULL];
        }
    }
}



@end
