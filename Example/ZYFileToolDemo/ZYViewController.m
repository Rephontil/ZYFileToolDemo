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
    NSDictionary<NSFileAttributeKey, id> *dic = [ZYFileTool attributeOfItemAtPath:newPath errorBlock:nil];
    NSLog(@"文件信息%@ -- %@",dic,dic[NSFileType]);
    
    NSString *fileSize = [ZYFileTool sizeOfFileAtPath:filePath errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    NSArray *listArr = [ZYFileTool listFileInDirectoryAtPath:path searchDeeply:NO errorBlock:^(NSError *error) {
        NSLog(@"Just errors %@",error);
    }];
    
    NSString *totalSize = [ZYFileTool sizeOfDirectoryAtPath:path searchDeeply:YES errorBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
