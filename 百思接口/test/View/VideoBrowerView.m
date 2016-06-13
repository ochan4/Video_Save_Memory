//
//  VideoView.m
//  test
//
//  Created by jc on 16/6/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "VideoBrowerView.h"
#import <MediaPlayer/MPMediaPlayback.h>
#import "AFNetworking.h"
@implementation VideoBrowerView

-(void)setShow:(ShowModel *)show{
    _show = show;
    
    //清空自身显示的之前的图片
    for (UIImageView *iv in self.subviews) {
        [iv removeFromSuperview];
    }
    
    //视频预览图
    UIImageView *iv = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ImageWidth, ImageHeight)];
//    iv.image = [KrVideoPlayerController thumbnailImageForVideo:[NSURL URLWithString:_show.video_uri] atTime:1];
    iv.contentMode = UIViewContentModeScaleAspectFill;
    iv.clipsToBounds = YES;
    [self addSubview:iv];
    
    NSString *str = NSHomeDirectory();
//    NSLog(@"%@",str);
    self.strPath = [NSString stringWithFormat:@"%@/Documents",str];
//    NSLog(@"%@",self.strPath);
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", self.strPath, [[show.video_uri componentsSeparatedByString:@"/"] lastObject]];
    
    if ([fileManager fileExistsAtPath:fileName]) {

        
        iv.image = [KrVideoPlayerController thumbnailImageForVideo:[NSURL fileURLWithPath:fileName] atTime:3];
        NSLog(@"1******%@",[NSURL fileURLWithPath:fileName]);
        
        
        UIButton *ImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenW/4, ScreenW/4)];
        ImageBtn.tag = 0;
        ImageBtn.center = iv.center;
        [ImageBtn setImage:[UIImage imageNamed:@"PlayVideoImage"] forState:UIControlStateNormal];
        [self addSubview:ImageBtn];
        [ImageBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        iv.image = [KrVideoPlayerController thumbnailImageForVideo:[NSURL URLWithString:_show.video_uri] atTime:3];
        NSLog(@"2******%@",[NSURL URLWithString:_show.video_uri]);
        
        UIButton *ImageBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenW/4, ScreenW/4)];
        ImageBtn.tag = 1;
        ImageBtn.center = iv.center;
        [ImageBtn setImage:[UIImage imageNamed:@"PlayVideoImage"] forState:UIControlStateNormal];
        [self addSubview:ImageBtn];
        [ImageBtn addTarget:self action:@selector(playVideo:) forControlEvents:UIControlEventTouchUpInside];
    }

    

}

- (void)playVideo:(UIButton *)btn{
//    NSURL *url = [NSURL URLWithString:_show.video_uri];
//    [self addVideoPlayerWithURL:url];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", self.strPath, [[_show.video_uri componentsSeparatedByString:@"/"] lastObject]];
    
    switch (btn.tag) {
        case 0:
        {
            [self addVideoPlayerWithURL:[NSURL fileURLWithPath:fileName]];
        }
            break;
        case 1:
        {
            
            //创建附件存储目录
            if (![fileManager fileExistsAtPath:self.strPath]) {
                [fileManager createDirectoryAtPath:self.strPath withIntermediateDirectories:YES attributes:nil error:nil];
            }
            //         [self addVideoPlayerWithURL:[NSURL fileURLWithPath:fileName]];
            [self addVideoPlayerWithURL:[NSURL URLWithString:_show.video_uri]];
            //下载附件
            NSURL *url = [[NSURL alloc] initWithString:_show.video_uri];
            NSURLRequest *request = [NSURLRequest requestWithURL:url];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            operation.inputStream   = [NSInputStream inputStreamWithURL:url];
            operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
            
            //下载进度控制
            
            [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
                NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
            }];
            
            //已完成下载
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                //            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
                NSLog(@"完成下载");
                //设置下载数据到res字典对象中并用代理返回下载数据NSData
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                NSLog(@"下载失败");
                //下载失败
            }];
            
            [operation start];
            
        }
            break;
    }
    
    
}

- (void)addVideoPlayerWithURL:(NSURL *)url{
    if (!self.videoController) {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        self.videoController = [[KrVideoPlayerController alloc] initWithFrame:CGRectMake(0, 64, width, width*(9.0/16.0))];
        __weak typeof(self)weakSelf = self;
        [self.videoController setDimissCompleteBlock:^{
            weakSelf.videoController = nil;
        }];
        [self.videoController setWillBackOrientationPortrait:^{
            [weakSelf toolbarHidden:NO];
        }];
        [self.videoController setWillChangeToFullscreenMode:^{
            [weakSelf toolbarHidden:YES];
        }];
        [self.window.rootViewController.view addSubview:self.videoController.view];
    }
    self.videoController.contentURL = url;
    
}
//隐藏navigation tabbar 电池栏
- (void)toolbarHidden:(BOOL)Bool{
    self.window.rootViewController.navigationController.navigationBar.hidden = Bool;
    self.window.rootViewController.tabBarController.tabBar.hidden = Bool;
    [[UIApplication sharedApplication] setStatusBarHidden:Bool withAnimation:UIStatusBarAnimationFade];
}

/**
 * 下载文件
 */
- (void)downloadFileURL:(NSString *)aUrl savePath:(NSString *)aSavePath fileName:(NSString *)aFileName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //检查本地文件是否已存在
    NSString *fileName = [NSString stringWithFormat:@"%@/%@", aSavePath, aFileName];
    
    //检查附件是否存在
    if ([fileManager fileExistsAtPath:fileName]) {
        [self addVideoPlayerWithURL:[NSURL fileURLWithPath:fileName]];
    }else{
        //创建附件存储目录
        if (![fileManager fileExistsAtPath:aSavePath]) {
            [fileManager createDirectoryAtPath:aSavePath withIntermediateDirectories:YES attributes:nil error:nil];
        }
        //         [self addVideoPlayerWithURL:[NSURL fileURLWithPath:fileName]];
        [self addVideoPlayerWithURL:[NSURL URLWithString:aUrl]];
        //下载附件
        NSURL *url = [[NSURL alloc] initWithString:aUrl];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.inputStream   = [NSInputStream inputStreamWithURL:url];
        operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:fileName append:NO];
        
        //下载进度控制
        
        [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
            NSLog(@"is download：%f", (float)totalBytesRead/totalBytesExpectedToRead);
        }];
        
        //已完成下载
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            //            NSData *audioData = [NSData dataWithContentsOfFile:fileName];
            NSLog(@"完成下载");
            //设置下载数据到res字典对象中并用代理返回下载数据NSData
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"下载失败");
            //下载失败
        }];
        
        [operation start];
    }
}

@end
