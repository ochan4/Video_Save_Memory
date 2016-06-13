//
//  imageBrowerVIew.h
//  ITSMS
//
//  Created by jc on 16/5/18.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowModel.h"
@interface ImageBrowerView : UIView
@property(nonatomic,strong)ShowModel *show;
@property (nonatomic, strong) CAShapeLayer *progressLayer;
@end
