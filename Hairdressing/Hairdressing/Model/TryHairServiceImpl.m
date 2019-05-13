//
//  TryHairServiceImpl.m
//  Hairdressing
//
//  Created by Guolong Yang on 16/4/5.
//  Copyright © 2016年 Yangjiaolong. All rights reserved.
//

#import "TryHairServiceImpl.h"
#import <AFNetworking/AFNetworking.h>
#import <SSZipArchive/SSZipArchive.h>
#import "Utility.h"



@implementation TryHairServiceImpl
///[NSURL URLWithString:@"http://Guolong Yangdeimac.local:8000/HairModel.zip"]


-(RACSignal *)getHairType{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[@{}];

    return [super requestDataFromNetWithParams:parameters withAction:@"getHairType"];
        
}

-(RACSignal *)getHairStyleListWithHairTypeId:(NSString *)hairtypeId pNo:(int)pNo pSize:(int)pSize{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"jsonrpc"] = @"2.0";
    parameters[@"params"] = @[@{@"hairTypeId":hairtypeId,@"pNo":@(pNo),@"pSize":@(pSize)}];
    return [super requestDataFromNetWithParams:parameters withAction:@"getHairstyleList"];
}

- (RACSignal *)downloadFileWithHairModelName:(NSString *)modelName withHairModelId:(NSString *)hmid{
    return [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
//        NSString * modelstr = [[modelName componentsSeparatedByString:@"/"] lastObject];
        
        if ([Utility isFileExistInHairModelDir:hmid]) {
            NSLog(@"use local data");
            [subscriber sendNext:[Utility getHairModelDirWithName:hmid]];
            [subscriber sendCompleted];
            return nil;
        }

        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:modelName]];
        
        NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
            
       //     [subscriber sendNext:[NSString stringWithFormat:@"%f", downloadProgress.fractionCompleted]];
            
        } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
            NSURL *downloadURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
            return [downloadURL URLByAppendingPathComponent:[response suggestedFilename]];
        } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
            if (error) {
                [subscriber sendError:error];
                return ;
            }
            // 创建文件目录
    
            NSString *destinationDir = [[Utility getHairModelDir] stringByAppendingPathComponent:hmid];//:
            NSString *filePaths = [[filePath absoluteString] stringByReplacingOccurrencesOfString:@"file://" withString:@""];
            
            [SSZipArchive unzipFileAtPath:filePaths toDestination:destinationDir progressHandler:^(NSString *entry, unz_file_info zipInfo, long entryNumber, long total) {
                
            } completionHandler:^(NSString *path, BOOL succeeded, NSError *error) {
                if(succeeded)
                {
                    NSLog(@"download from server");
                    [subscriber sendNext:destinationDir];
                    if ( [[NSFileManager defaultManager] removeItemAtPath:filePaths error:nil]) {
                        DLog(@"删除 %@ 压缩包成功",hmid);
                    }else{
                        DLog(@"删除 %@ 压缩包失败",hmid);

                    }
                    [subscriber sendCompleted];
                }
                else
                {
                    NSLog(@"%@",error.localizedDescription);
                    [subscriber sendError:error];
                }
            }];
        }];
        [downloadTask resume];
        return [RACDisposable disposableWithBlock:^{
            [downloadTask cancel];
        }];
    }]
            replayLazily];
}






@end
