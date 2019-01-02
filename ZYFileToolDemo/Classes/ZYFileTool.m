//
//  ZYFileTool.m
//  ZYFileTool_Example
//
//  Created by 周勇 on 2017/1/2.
//  Copyright © 2017 Rephontil. All rights reserved.
//

#import "ZYFileTool.h"

@implementation ZYFileTool


+ (BOOL)isFileAtPath:(NSString *)path{
    BOOL status = true;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&status];
    if (result && !status) {
        return true;
    }else{
        return false;
    }
}

+ (BOOL)isDirectoryAtPath:(NSString *)path{
    BOOL status = true;
    BOOL result = [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&status];
    if (result && status) {
        return true;
    }else{
        return false;
    }
}

+ (NSDictionary<NSFileAttributeKey, id> *)attributeOfItemAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock  {
    
    NSError *error = nil;
    NSDictionary<NSFileAttributeKey, id> *infoDic = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:&error];
    if (error) {
        !errorBlock ? : errorBlock(error);
    }
    
    return infoDic;
}

+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key errorBlock:(void(^)(NSError *error))errorBlock {
    
    return [[self attributeOfItemAtPath:path errorBlock:errorBlock] objectForKey:key];
}

/**
 是否是文件
 
 @param path 目标路径
 */
+ (BOOL)isFileAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock{
    BOOL isFile = [self attributeOfItemAtPath:path forKey:NSFileType errorBlock:errorBlock] == NSFileTypeRegular;
    if (!isFile) {
        NSCAssert(isFile == 1, @"请检查文件路径");
    }
    return isFile;
}

/**
 是否是文件夹
 
 @param path 目标路径
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock{
    BOOL isDirectory = [self attributeOfItemAtPath:path forKey:NSFileType errorBlock:errorBlock] == NSFileTypeDirectory;
    if (!isDirectory) {
        NSCAssert(isDirectory == 1, @"请检查文件夹路径");
    }
    return isDirectory;
}


#pragma mark 将文件大小格式化为字节
+ (NSString *)sizeFormatted:(NSString *)size {
    /*NSByteCountFormatterCountStyle枚举
     *NSByteCountFormatterCountStyleFile 字节为单位，采用十进制的1000bytes = 1KB
     *NSByteCountFormatterCountStyleMemory 字节为单位，采用二进制的1024bytes = 1KB
     *NSByteCountFormatterCountStyleDecimal KB为单位，采用十进制的1000bytes = 1KB
     *NSByteCountFormatterCountStyleBinary KB为单位，采用二进制的1024bytes = 1KB
     */
//      return [NSByteCountFormatter stringFromByteCount:[size unsignedLongLongValue] countStyle:NSByteCountFormatterCountStyleFile];
    return [NSByteCountFormatter stringFromByteCount:[size longLongValue] countStyle:NSByteCountFormatterCountStyleFile];
}

#pragma mark 获取文件的大小
+ (NSString *)sizeOfFileAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock {
    
    if ([self isFileAtPath:path errorBlock:errorBlock]) {
        NSString *fileSize =  (NSString *)[self attributeOfItemAtPath:path forKey:NSFileSize errorBlock:errorBlock];
        return [self sizeFormatted:fileSize];
    }
    
    return nil;
}

#pragma mark 获取文件夹的大小
+ (NSString *)sizeOfDirectoryAtPath:(NSString *)path searchDeeply:(BOOL)searchDeeply errorBlock:(void(^)(NSError *error))errorBlock {
    
    if ([self isDirectoryAtPath:path errorBlock:errorBlock]) {
        //深遍历文件夹
        NSArray *subPaths = [self listFileInDirectoryAtPath:path searchDeeply:searchDeeply errorBlock:errorBlock];
        NSEnumerator *contentsEnumurator = [subPaths objectEnumerator];
        
        NSString *file;
        unsigned long long int folderSize = 0;
        
        while (file = [contentsEnumurator nextObject]) {
            NSDictionary *fileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:[path stringByAppendingPathComponent:file] error:nil];
            folderSize += [[fileAttributes objectForKey:NSFileSize] intValue];
        }
        NSNumber *sizeNum = [NSNumber numberWithUnsignedLongLong:folderSize];
        NSString *sizeStr = [NSString stringWithFormat:@"%@",sizeNum];
        return  [self sizeFormatted:sizeStr];
    }
    
    return nil;
}

//获取指定路径下的子文件数组
+ (NSArray *)listFileInDirectoryAtPath:(NSString *)path searchDeeply:(BOOL)searchDeeply errorBlock:(void(^)(NSError *error))errorBlock{
    
    NSFileManager *manager = [NSFileManager defaultManager];
    NSArray *listArr = nil;
    NSError *error = nil;
    if (searchDeeply) {
        NSArray *deepArr = [manager subpathsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = deepArr;
        } else {
            listArr = nil;
            if (errorBlock) {
                errorBlock(error);
            }
        }
    } else {
        NSArray *shadowArr = [manager contentsOfDirectoryAtPath:path error:&error];
        if (!error) {
            listArr = shadowArr;
        } else {
            listArr = nil;
            if (errorBlock) {
                errorBlock(error);
            }
        }
    }
    NSLog(@"listArr ===> %@",listArr);
    return listArr;
}

+ (void)removeItemAtPath:(NSString *)path successBlock:(void(^)(bool status))successBlock{
    
    BOOL exist = [[NSFileManager defaultManager] fileExistsAtPath:path];
    if (exist == 0) {
        NSCAssert(exist == 1, @"请检查文件路径");
    }
    
    
    NSError *error = nil;
    BOOL result = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
    successBlock(result);
    if (error) {
        NSLog(@"%@",error);
    }
}


@end
