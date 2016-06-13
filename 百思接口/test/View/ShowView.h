//
//  ShowView.h
//  test
//
//  Created by jc on 16/6/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowModel.h"
#import "ImageBrowerView.h"
#import "VideoBrowerView.h"
@interface ShowView : UIView
//模型
@property(nonatomic,strong)ShowModel *show;
//图片
@property(nonatomic,strong)ImageBrowerView *img_content;
//视频
@property(nonatomic,strong)VideoBrowerView *img_video;
//文本
@property(nonatomic,strong)UILabel *content;
//边框
@property(nonatomic,strong)UIImageView* all_content_bg;
//时间
@property(nonatomic,strong)UILabel *create_time;
//按钮托盘
@property(nonatomic,strong)UIView *btnView;
@property(nonatomic,strong)UIButton *loveBtn;
@property(nonatomic,strong)UIButton *hateBtn;
@end
