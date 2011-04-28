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
	BOOL hasHighResScreen = NO;
	if ([UIScreen instancesRespondToSelector:@selector(scale)]) {
		CGFloat scale = [[UIScreen mainScreen] scale];
		if (scale > 1.0) {
			hasHighResScreen = YES;
		}
	}
	
    float actualHeight = image.size.height;
    float actualWidth = image.size.width;
    float imgRatio = actualWidth/actualHeight;
	
	float maxRatio;
	float height;
	float width;
	
	if(hasHighResScreen == YES)
	{
		maxRatio = 434/508;
		height = 508;
		width = 434;
	}
	else
	{
		maxRatio = 217/254.0;
		height = 254.0;
		width = 217;
    }
	
    if(imgRatio!=maxRatio){
        if(imgRatio < maxRatio){
            imgRatio = height / actualHeight;
            actualWidth = imgRatio * actualWidth;
            actualHeight = height;
        }
        else{
            imgRatio = width / actualWidth;
            actualHeight = imgRatio * actualHeight;
            actualWidth = width;
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

+ (NSMutableArray*)scanMangaDir:(NSString*)mangaDir {
    NSFileManager * filemanager = [NSFileManager defaultManager];
    NSString *file;
    NSMutableArray * imageArray = [NSMutableArray array];
	
    //Get all of the files in the source directory, loop thru them.
    NSEnumerator *files = [filemanager enumeratorAtPath:mangaDir];
    while((file = [files nextObject]) ) {
        //Only looking for jpg
        if( [[file pathExtension] isEqualToString:@"jpg"] || [[file pathExtension] isEqualToString:@"png"] )
        {
			[imageArray addObject:[mangaDir stringByAppendingPathComponent:file]];
        }
    }
    
    //We have nothing so return nil
    return imageArray;
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
        if( [[file pathExtension] isEqualToString:@"jpg"] || [[file pathExtension] isEqualToString:@"png"] )
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

#pragma mark Extracting zips
+ (void)extractFilesFromZip:(ReadMangaViewController *)sender {
    NSAutoreleasePool *pool= [[NSAutoreleasePool alloc] init];
    
    ZipFile *unzipFile= [[ZipFile alloc] initWithFileName:sender.zipPath mode:ZipFileModeUnzip];
    NSArray *infos= [unzipFile listFileInZipInfos];
    
    int count = 0;
    float progress = 0;
    [sender.zipProgressView setProgress:progress];
    
    NSArray * paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString * cacheDirectory = [paths objectAtIndex:0];
    NSString * mangaCleanName = [sender.mangaName stringByDeletingPathExtension];
    NSString * mangaDirectory = [cacheDirectory stringByAppendingPathComponent:mangaCleanName];
    NSMutableArray * fileArray = [NSMutableArray array];
	
    NSFileManager * filemanager = [NSFileManager defaultManager];
    
    //Dir does not exist: create it
    BOOL isDir;
    if(![filemanager fileExistsAtPath:mangaDirectory isDirectory:&isDir] || !isDir)
    {
        [filemanager createDirectoryAtPath:mangaDirectory withIntermediateDirectories:NO attributes:nil error:NULL];
        [filemanager createDirectoryAtPath:[mangaDirectory stringByAppendingPathComponent:@"previews"] withIntermediateDirectories:NO attributes:nil error:NULL];
		
        for (FileInZipInfo *info in infos) {
            //NSLog(@"- %@ %@ %d (%d)", info.name, info.date, info.size, info.level);
            
            // Locate the file in the zip
            [unzipFile locateFileInZip:info.name];
            
            
            if([info.name hasSuffix:@".jpg"] || [info.name hasSuffix:@".JPG"] || [info.name hasSuffix:@".PNG"] || [info.name hasSuffix:@".png"] || [info.name hasSuffix:@".GIF"] || [info.name hasSuffix:@".gif"])
            {
                
                NSLog(@"%@ == image file", info.name);
                
                NSMutableArray * targetPathComponents = [NSMutableArray arrayWithCapacity:[[info.name pathComponents] count]];
                [targetPathComponents addObjectsFromArray:[info.name pathComponents]];
                [targetPathComponents removeLastObject];
                
                if([targetPathComponents count] >= 1)
                {
                    [FileUtils createDirWithTargetPathComponents:targetPathComponents withMangaDir:mangaDirectory];
                }
                
                // Expand the file in memory
                ZipReadStream *read= [unzipFile readCurrentFileInZip];
                NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
                int bytesRead= [read readDataWithBuffer:data];
                [read finishedReading];
                
				//Rename the image
				NSString*filePathAsPNG = [[info.name stringByDeletingPathExtension]stringByAppendingString:@".png"];
                NSString * theTargetDir = [mangaDirectory stringByAppendingPathComponent:filePathAsPNG];
                
                [FileUtils createFileWithData:UIImagePNGRepresentation([UIImage imageWithData:data]) atPath:theTargetDir];
                
                if(count == 0 || count == 1 || count == 2)
                {
                    NSData *filedata = UIImagePNGRepresentation([FileUtils imageWithImage:[UIImage imageWithData:data]]);
					[FileUtils createFileWithData:filedata atPath:[[mangaDirectory stringByAppendingPathComponent:@"previews"] stringByAppendingPathComponent: [info.name lastPathComponent]]];
                }
				
                [fileArray addObject:info.name];
				
                //Update Progress
                count++;
                progress = (float) count / [infos count];
                [sender performSelectorOnMainThread:@selector(loadingProgress:) withObject:[NSNumber numberWithFloat:progress] waitUntilDone:NO];
                NSLog(@"Progress %f", progress);
                
				bytesRead =0;
                targetPathComponents = nil;
				filePathAsPNG = nil;
            }
            
            if([info.name hasSuffix:@".txt"] || [info.name hasSuffix:@".TXT"])
            {
                NSLog(@"%@ == text file", info.name);
                NSMutableArray * targetPathComponents = [NSMutableArray arrayWithCapacity:[[info.name pathComponents] count]];
                [targetPathComponents addObjectsFromArray:[info.name pathComponents]];
                [targetPathComponents removeLastObject];
                
                if([targetPathComponents count] >= 1)
                {
                    [FileUtils createDirWithTargetPathComponents:targetPathComponents withMangaDir:mangaDirectory];
                }
                
                // Expand the file in memory
                ZipReadStream *read= [unzipFile readCurrentFileInZip];
                NSMutableData *data= [[NSMutableData alloc] initWithLength:info.length];
                int bytesRead= [read readDataWithBuffer:data];
                [read finishedReading];
                
                //Set the info's on the screen
                sender.readmeString = [[[NSString alloc] initWithBytes:[data bytes] length:bytesRead encoding:NSUTF8StringEncoding] autorelease];
                [sender.readMeDetailView performSelectorOnMainThread:@selector(setText:) withObject:sender.readmeString waitUntilDone:NO];
                
                //Save the file
                NSString * theTargetDir = [mangaDirectory stringByAppendingPathComponent:info.name];
                [FileUtils createFileWithData:data atPath:theTargetDir];
				
                targetPathComponents = nil;
            }
        }
        [sender.zipProgressView setProgress:1];
    }
    
    [unzipFile close];
    [unzipFile release];
    
    int page = sender.screenshotPreviewPageControl.currentPage;
	
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [sender loadScrollViewWithPage:page - 1];
    [sender loadScrollViewWithPage:page];
    [sender loadScrollViewWithPage:page + 1];
    
	[sender.loadingLabel performSelectorOnMainThread:@selector(setText:) withObject:@"Manga Loaded" waitUntilDone:NO];
	[sender.ReadMangaButton setEnabled:YES];
	[sender.zipProgressView setHidden:YES];
	UIImage * previewPic = [FileUtils scanMangaDirForPreviewPic:mangaDirectory];
    [sender.previewPic performSelectorOnMainThread:@selector(setImage:) withObject:previewPic waitUntilDone:NO];
	sender.delegate.filearray = fileArray;
	
	[pool drain];
}



@end


CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect) {
	CGFloat scaleFactor = MIN(outerRect.size.width/innerRect.size.width, outerRect.size.height/innerRect.size.height);
	CGAffineTransform scale = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
	CGRect scaledInnerRect = CGRectApplyAffineTransform(innerRect, scale);
	CGAffineTransform translation = 
	CGAffineTransformMakeTranslation((outerRect.size.width - scaledInnerRect.size.width) / 2 - scaledInnerRect.origin.x, 
									 (outerRect.size.height - scaledInnerRect.size.height) / 2 - scaledInnerRect.origin.y);
	return CGAffineTransformConcat(scale, translation);
}


