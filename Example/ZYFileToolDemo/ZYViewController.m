//
//  ZYViewController.m
//  ZYFileTool
//
//  Created by Rephontil on 01/02/2019.
//  Copyright (c) 2019 Rephontil. All rights reserved.
//

#import "ZYViewController.h"
#import "ZYFileTool.h"

@interface ZYViewController ()

@property (nonatomic, copy) NSString *dirPath;
@property (nonatomic, copy) NSString *imagePath;

@end

@implementation ZYViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initFilePath];
    
    
    [self saveImage];
    
    [self demoTest];
    
    [self removeFileOrDir];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)initFilePath{
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES).lastObject;
    NSString *dirPath = [path stringByAppendingPathComponent:@"ZYDirectory"];
    [[NSFileManager defaultManager] createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
    self.dirPath = dirPath;
}

- (void)saveImage{
    self.imagePath = [self.dirPath stringByAppendingPathComponent:@"image.png"];
    UIImage *image = [UIImage imageNamed:@"image.png"];
    BOOL result = [UIImagePNGRepresentation(image) writeToFile:self.imagePath atomically:YES];
    NSLog(@"图片写入沙盒状态 %d",result);
}

- (void)demoTest{
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZYDirectory/image.png"];
    
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ZYDirectory"];
    
    BOOL status1 = [ZYFileTool isFileAtPath:filePath];
    BOOL status2 = [ZYFileTool isDirectoryAtPath:filePath];
    BOOL status3 = [ZYFileTool isFileAtPath:path];
    BOOL status4 = [ZYFileTool isDirectoryAtPath:path];
    NSLog(@"%d -- %d -- %d -- %d ",status1,status2,status3,status4);
    
    
    NSString *newPath = [path stringByAppendingPathComponent:@"image.png"];
    
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wnonnull"
    NSDictionary<NSFileAttributeKey, id> *dic = [ZYFileTool attributeOfItemAtPath:newPath errorBlock:nil];
#pragma clang diagnostic pop
    
    NSLog(@"文件信息全部%@ -- 路径对应的文件类型%@",dic,dic[NSFileType]);
    
     //获取文件的大小
    NSString *fileSize = [ZYFileTool sizeOfFileAtPath:filePath errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    //获取path路径下文件列表（支持浅遍历和深度遍历）
    NSArray *listArr = [ZYFileTool listFileInDirectoryAtPath:path searchDeeply:NO errorBlock:^(NSError *error) {
        NSLog(@"Just errors %@",error);
    }];
    
    //获取文件夹的大小，深度遍历子文件
    NSString *totalSize = [ZYFileTool sizeOfDirectoryAtPath:path searchDeeply:YES errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    NSLog(@"fileSize = %@ -- listArr = %@ --totalSize = %@",fileSize, listArr, totalSize);
}

- (void)removeFileOrDir{
    [ZYFileTool removeItemAtPath:self.dirPath successBlock:^(bool status) {
        if (status) {
            NSLog(@"移除文件夹成功");
        }else{
            NSLog(@"移除文件夹失败");
        }
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
