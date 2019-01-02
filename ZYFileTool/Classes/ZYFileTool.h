//
//  ZYFileTool.h
//  ZYFileTool_Example
//
//  Created by 周勇 on 2017/1/2.
//  Copyright © 2017 Rephontil. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYFileTool : NSObject


//Basic Methods
+ (NSString *)homeDir;
+ (NSString *)documentDir;
+ (NSString *)libraryDir;
+ (NSString *)cachesDir;
+ (NSString *)preferencesDir;
+ (NSString *)tmpDir;

+ (BOOL)isFileAtPath:(NSString *)path;
+ (BOOL)isDirectoryAtPath:(NSString *)path;


//File Operations
+ (BOOL)createDirAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock;

+ (NSDictionary<NSFileAttributeKey, id> *)attributeOfItemAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock;

+ (id)attributeOfItemAtPath:(NSString *)path forKey:(NSString *)key errorBlock:(void(^)(NSError *error))errorBlock;

/**
 是否是文件
 
 @param path 目标路径
 */
+ (BOOL)isFileAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock;

/**
 是否是文件夹
 
 @param path 目标路径
 */
+ (BOOL)isDirectoryAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock;

// 将文件大小格式化为字节
+ (NSString *)sizeFormatted:(NSString *)size;

// 获取文件的大小
+ (NSString *)sizeOfFileAtPath:(NSString *)path errorBlock:(void(^)(NSError *error))errorBlock;

// 获取文件夹的大小
+ (NSString *)sizeOfDirectoryAtPath:(NSString *)path searchDeeply:(BOOL)searchDeeply errorBlock:(void(^)(NSError *error))errorBlock;

//获取指定路径下的子文件数组
+ (NSArray *)listFileInDirectoryAtPath:(NSString *)path searchDeeply:(BOOL)searchDeeply errorBlock:(void(^)(NSError *error))errorBlock;

//删除指定位置的文件或文件夹
+ (void)removeItemAtPath:(NSString *)path successBlock:(void(^)(bool status))successBlock;


@end

NS_ASSUME_NONNULL_END
