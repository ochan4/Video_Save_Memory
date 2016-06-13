//
//  VideoView.h
//  test
//
//  Created by jc on 16/6/9.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowModel.h"
@interface VideoBrowerView : UIView
@property(nonatomic,strong)ShowModel *show;
@property (nonatomic, strong) KrVideoPlayerController  *videoController;
@property(nonatomic,strong)NSString *strPath;
@end
