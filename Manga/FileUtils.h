//
//  FileUtils.h
//  Manga
//
//  Created by Hidde Jansen on 13-03-11.
//  Copyright 2011 Epic-Win. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface FileUtils : NSObject {
    
}

+ (UIImage*)imageWithImage:(UIImage*)image;

+ (NSMutableArray*)listFiles;

+ (NSString*)scanMangaDirForReadMe:(NSString*)mangaDir;
+ (UIImage*)scanMangaDirForPreviewPic:(NSString*)mangaDir;

+ (void)createFileWithData:(NSData*)data atPath:(NSString*)filePath;
+ (void)createDirWithTargetPathComponents:(NSArray*)targetPathComponents withMangaDir:(NSString*)mangaDir;

@end
