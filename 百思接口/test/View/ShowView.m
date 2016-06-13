//
//  ShowView.m
//  test
//
//  Created by jc on 16/6/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ShowView.h"

@implementation ShowView
static  int i  = 0;
#pragma mark - 初始化方法
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //初始化边框
        [self Content_Bg_Action];
        
        //初始化内容
        [self ContentAction];
        
        //初始化时间
        [self TimeAction];
        
        //初始化图片
        [self ImageAction];
        
        //初始化视频
        [self VideoAction];
        
        //初始化按钮
        [self BtnAction];

    }
 
    return self;
}

#pragma mark - 模型set方法

-(void)setShow:(ShowModel *)show{
    i++;
    _show = show;
    
    _content.text = [[show.content componentsSeparatedByString:@"        "] lastObject];
    //设置label的最大行数
    _content.numberOfLines = 10;

    CGSize size = CGSizeMake(335, 1000);
    
    CGSize labelSize = [_content.text sizeWithFont:_content.font constrainedToSize:size lineBreakMode:NSLineBreakByClipping];
    
    _content.frame = CGRectMake(_all_content_bg.frame.origin.x+5, _all_content_bg.frame.origin.y+5, Content_bg_Width-30, labelSize.height);
    
    _create_time.text = show.create_time;
    _create_time.frame = CGRectMake(_content.frame.origin.x, labelSize.height, Content_bg_Width, 40);
    
    if (show.imagePath!=nil) {
        
        self.img_content.hidden = NO;
        self.img_video.hidden = YES;
        self.img_content.show = show;
        [self getImageHeight];
        [self bringSubviewToFront:self.img_content];
        
        _all_content_bg.frame = CGRectMake(10, 5, Content_bg_Width, _content.frame.size.height+_create_time.frame.size.height+_img_content.frame.size.height+ButtonSize/2);
        
    }else if (show.video_uri!=nil) {
        
        self.img_content.hidden = YES;
        self.img_video.hidden = NO;
        self.img_video.show = show;
        [self getVideoHeight];
        [self bringSubviewToFront:self.img_video];
        
        _all_content_bg.frame = CGRectMake(10, 5, Content_bg_Width, _content.frame.size.height+_create_time.frame.size.height+_img_video.frame.size.height+ButtonSize/2);
    }else{
        self.img_video.hidden = YES;
        self.img_content.hidden = YES;
        _all_content_bg.frame = CGRectMake(10, 5, Content_bg_Width, _content.frame.size.height+_create_time.frame.size.height+ButtonSize/2);
    }
    
    _all_content_bg.center = CGPointMake(ScreenW/2, _all_content_bg.center.y);
    [_loveBtn setTitle:show.love forState:UIControlStateNormal];
    [_hateBtn setTitle:show.hate forState:UIControlStateNormal];
    
    
    _btnView.frame = CGRectMake(10, _all_content_bg.frame.size.height-ButtonSize/2.7, Content_bg_Width, ButtonSize);
    
    self.frame = CGRectMake(0, 0, _all_content_bg.frame.size.width, _all_content_bg.frame.size.height+10);
}

#pragma mark - 初始化边框

-(void)Content_Bg_Action{
    _all_content_bg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, Content_bg_Width, 100 - 10)];
    [self addSubview:_all_content_bg];
    _all_content_bg.image = [UIImage imageNamed:@"mainCellAllKuang"];
//    _all_content_bg.highlightedImage = [UIImage imageNamed:@"all_kuang_up"];
    _all_content_bg.image = [_all_content_bg.image resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
    _all_content_bg.highlightedImage = [_all_content_bg.highlightedImage resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2) resizingMode:UIImageResizingModeStretch];
}

#pragma mark - 初始化文本内容

-(void)ContentAction{
    _content = [[UILabel alloc] initWithFrame:CGRectZero];
    _content.backgroundColor = [UIColor clearColor];
    _content.font = NewFont
    [_all_content_bg addSubview:_content];
    
}

#pragma mark - 初始化图片

-(void)ImageAction{
    
    self.img_content.hidden = NO;
    _img_content = [[ImageBrowerView alloc]initWithFrame:CGRectZero];
    [self addSubview:_img_content];
}

#pragma mark - 初始化视频

-(void)VideoAction{
    
    self.img_video.hidden = NO;
    _img_video = [[VideoBrowerView alloc]initWithFrame:CGRectZero];
    [self addSubview:_img_video];
}

#pragma mark - 初始化时间

-(void)TimeAction{
    
    //更新时间
    _create_time = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, Content_bg_Width, 40)];
    _create_time.backgroundColor = [UIColor clearColor];
    _create_time.font = NewFont
    [_all_content_bg addSubview:_create_time];
    
}

#pragma mark - 初始化“收藏”，“转发”，“点赞”，等等。。 按钮

-(void)BtnAction{
    _btnView = [[UIView alloc]initWithFrame:CGRectMake(0, _all_content_bg.frame.size.height-ButtonSize/1.5, Content_bg_Width, 50)];
    [self addSubview:_btnView];
    
    //喜欢按钮
    _loveBtn = [[UIButton alloc]initWithFrame:CGRectMake(ButtonSize*0, 0, ButtonSize, ButtonSize/3)];
    [_loveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _loveBtn.titleLabel.font = NewFont
    [_loveBtn setImage:[UIImage imageNamed:@"mainCellLove"] forState:UIControlStateNormal];
//    _loveBtn.imageView.highlightedImage = [UIImage imageNamed:@"mainCellLoveClick"];
//    [_loveBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //讨厌按钮
    _hateBtn = [[UIButton alloc]initWithFrame:CGRectMake(ButtonSize*1, 0, ButtonSize, ButtonSize/3)];
    [_hateBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    _hateBtn.titleLabel.font = NewFont
    [_hateBtn setImage:[UIImage imageNamed:@"mainCellHate"] forState:UIControlStateNormal];
//    _hateBtn.imageView.highlightedImage = [UIImage imageNamed:@"mainCellHateClick"];
//    [_hateBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //复制按钮
    UIButton *copyBtn = [[UIButton alloc]initWithFrame:CGRectMake(ButtonSize*2, 0, ButtonSize, ButtonSize/3)];
    copyBtn.tag = 0;
    [copyBtn setImage:[UIImage imageNamed:@"mainCellCopy"] forState:UIControlStateNormal];
//    copyBtn.imageView.highlightedImage = [UIImage imageNamed:@"mainCellCopyClick"];
    [copyBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [copyBtn setTitle:@"复制" forState:UIControlStateNormal];
    [copyBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    copyBtn.titleLabel.font = [UIFont fontWithName:@"FZMiaoWuS-GB" size:15];
    
    //收藏按钮
    UIButton *collectBtn = [[UIButton alloc]initWithFrame:CGRectMake(ButtonSize*3, 0, ButtonSize, ButtonSize/3)];
    collectBtn.tag = 1;
    [collectBtn setImage:[UIImage imageNamed:@"mainCellStar"] forState:UIControlStateNormal];
//    collectBtn.imageView.highlightedImage = [UIImage imageNamed:@"mainCellStarClick"];
    [collectBtn addTarget:self action:@selector(BtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    collectBtn.titleLabel.font = [UIFont fontWithName:@"FZMiaoWuS-GB" size:15];
    
    [_btnView addSubview:_loveBtn];
    [_btnView addSubview:_hateBtn];
    [_btnView addSubview:copyBtn];
    [_btnView addSubview:collectBtn];
    
}
-(void)BtnAction:(UIButton *)btn{
    
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 60)];
    label.center = CGPointMake(self.frame.size.width/2, self.window.frame.size.height/2);
    label.textAlignment = NSTextAlignmentCenter;
    label.numberOfLines = 2;
    label.textColor = [UIColor whiteColor];
    label.font = NewFont
    label.backgroundColor = [UIColor blackColor];
    label.alpha = 0;
    label.layer.cornerRadius = 16;
    label.layer.masksToBounds = YES;
    [self.window.rootViewController.view addSubview:label];
    
    switch (btn.tag) {
        case 0://复制按钮
        {
            label.text = @"已复制~                      您可以粘贴给小伙伴噢~";
            
            [UIView animateWithDuration:1.5 animations:^{
                label.alpha = .7;
                UIPasteboard* board = [UIPasteboard generalPasteboard];
                board.string = self.content.text;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:1.5 animations:^{
                    label.alpha = 0;
                }completion:^(BOOL finished) {
                    [label removeFromSuperview];
                }];
            }];
            
        }
            break;
        case 1://收藏按钮
        {
            label.text = @"收藏好咯~                  记得在收藏里回味噢~";
            
            [UIView animateWithDuration:1.5 animations:^{
                label.alpha = .7;
            }completion:^(BOOL finished) {
                [UIView animateWithDuration:1.5 animations:^{
                    label.alpha = 0;
                }completion:^(BOOL finished) {
                    [label removeFromSuperview];
                }];
            }];
            
        }
            break;
    }
}

#pragma mark - 计算有图片和视频时候的高度

-(void)getImageHeight{
     _img_content.frame = CGRectMake(_all_content_bg.frame.origin.x+_content.frame.origin.x*2, CGRectGetMaxY(_create_time.frame), ImageWidth, ImageHeight);
    _img_content.center = CGPointMake(ScreenW/2, CGRectGetMaxY(_create_time.frame)+ImageHeight/2);
//    NSLog(@"%lf",_img_content.frame.origin.y);
}
-(void)getVideoHeight{
    _img_video.frame = CGRectMake(_all_content_bg.frame.origin.x+_content.frame.origin.x*2, CGRectGetMaxY(_create_time.frame), ImageWidth, ImageHeight);
    _img_video.center = CGPointMake (ScreenW/2, CGRectGetMaxY(_create_time.frame)+ImageHeight/2);
//    NSLog(@"%lf",_img_video.frame.origin.y);
}


@end
