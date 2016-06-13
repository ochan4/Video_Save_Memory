//
//  DuanTableViewCell.m
//  test
//
//  Created by jc on 16/5/31.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "DuanTableViewCell.h"


@implementation DuanTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _showView = [[ShowView alloc]initWithFrame:CGRectZero];
        [self.contentView addSubview:_showView];
        self.selectedBackgroundView = [UIView new];
    }
    return self;
}

#pragma mark - 赋值和自动换行，计算cell和其他控件的高度
        
//        UIImage *shotImage;
//        //视频路径URL
//        NSURL *fileURL = [NSURL fileURLWithPath:_videoPath];
//        
//        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:fileURL options:nil];
//        
//        AVAssetImageGenerator *gen = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//        
//        gen.appliesPreferredTrackTransform = YES;
//        
//        CMTime time = CMTimeMakeWithSeconds(0.0, 600);
//        
//        NSError *error = nil;
//        
//        CMTime actualTime;
//        
//        CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//        
//        shotImage = [[UIImage alloc] initWithCGImage:image];
//        
//        _videoImage = [[UIImageView alloc] initWithFrame:CGRectMake(_content.frame.origin.x, _content.frame.size.height+5, ImageWidth, ImageHeight)];
//        _videoImage.contentMode = UIViewContentModeScaleAspectFill;
//        _videoImage.userInteractionEnabled = YES;
//        _videoImage.clipsToBounds = YES;
//        _videoImage.image = shotImage;
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(playVideo)];
//        [_videoImage addGestureRecognizer:tap];
//        
//        [self addSubview:_videoImage];


-(void)setShow:(ShowModel *)show{
    _show  = show;
    
    _showView.show = show;
    
    self.frame = _showView.frame;

}

@end
