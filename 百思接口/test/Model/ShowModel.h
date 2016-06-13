//
//  UserModel.h
//  test
//
//  Created by jc on 16/5/31.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShowModel : NSObject
//正文
@property (nonatomic,copy) NSString *content;
//图片
@property (nonatomic,copy) NSString *imagePath;
//视频
@property (nonatomic,copy) NSString *video_uri;
//时间
@property (nonatomic,copy) NSString *create_time;
//喜欢数
@property (nonatomic,copy) NSString *love;
//讨厌数
@property (nonatomic,copy) NSString *hate;

@end
