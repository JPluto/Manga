//
//  FileUtils.h
//  Manga
//
//  Created by Hidde Jansen on 13-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ReadMangaViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import "ZipFile.h"
#import "ZipException.h"
#import "FileInZipInfo.h"
#import "ZipWriteStream.h"
#import "ZipReadStream.h"

@class ReadMangaViewController;

@interface FileUtils : NSObject {
    
}

+ (UIImage*)imageWithImage:(UIImage*)image;

+ (NSMutableArray*)listFiles;

+ (NSMutableArray*)scanMangaDir:(NSString*)mangaDir;	
+ (NSString*)scanMangaDirForReadMe:(NSString*)mangaDir;
+ (UIImage*)scanMangaDirForPreviewPic:(NSString*)mangaDir;

+ (void)createFileWithData:(NSData*)data atPath:(NSString*)filePath;
+ (void)createDirWithTargetPathComponents:(NSArray*)targetPathComponents withMangaDir:(NSString*)mangaDir;

+ (void)extractFilesFromZip:(ReadMangaViewController*)sender;
@end


CGAffineTransform aspectFit(CGRect innerRect, CGRect outerRect);