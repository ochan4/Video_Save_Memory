//
//  imageBrowerVIew.m
//  ITSMS
//
//  Created by jc on 16/5/18.
//  Copyright © 2016年 Tarena. All rights reserved.
//
#import "imageBrowerVIew.h"
#import "MJPhotoBrowser.h"
#import "MJPhotoView.h"
#import "MJPhoto.h"
@interface ImageBrowerView ()
{
    NSMutableArray *_urls;
}
@end
@implementation ImageBrowerView
-(void)setShow:(ShowModel *)show{
    _show = show;
    
    //清空自身显示的之前的图片
    for (UIImageView *iv in self.subviews) {
        [iv removeFromSuperview];
        [_urls removeObject:iv];
    }
    
    _urls = [NSMutableArray array];
    [_urls addObject:show.imagePath];
    
    // 1.UIImageView
    UIImage *placeholder = [UIImage imageNamed:@"ImageLoading"];

    for (int i = 0; i<_urls.count; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        [self addSubview:imageView];
        
        // 计算位置
        imageView.frame = CGRectMake(0, 0, ImageWidth, ImageHeight);

        // 下载图片
        [imageView sd_setImageWithURL:_urls[i] placeholderImage:placeholder];
        
        // 事件监听
        imageView.tag = i;
        imageView.userInteractionEnabled = YES;
        [imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
        
        // 内容模式
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //图片提示配图
        UILabel *imagePS = [[UILabel alloc]initWithFrame:CGRectMake(0, ImageHeight-40, ImageWidth, 40)];
        imagePS.backgroundColor = [UIColor blackColor];
        imagePS.alpha = .5;
        imagePS.text = @"点击查看大图";
        imagePS.textColor = [UIColor whiteColor];
        imagePS.textAlignment = NSTextAlignmentCenter;
        imagePS.font = NewFont
        [imageView addSubview:imagePS];
    }

}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    // 1.封装图片数据
    NSMutableArray *photos = [NSMutableArray arrayWithCapacity:_urls.count];
    for (int i = 0; i<_urls.count; i++) {
        // 替换为中等尺寸图片
        NSString *url = [_urls[i] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
        MJPhoto *photo = [[MJPhoto alloc] init];
        photo.url = [NSURL URLWithString:url]; // 图片路径
        photo.srcImageView = self.subviews[i]; // 来源于哪个UIImageView
        [photos addObject:photo];
    }
    
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = tap.view.tag; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

@end
