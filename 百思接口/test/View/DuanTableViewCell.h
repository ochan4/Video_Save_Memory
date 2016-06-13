//
//  DuanTableViewCell.h
//  test
//
//  Created by jc on 16/5/31.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ShowModel.h"
#import "ShowView.h"
@interface DuanTableViewCell : UITableViewCell
@property(nonatomic,strong)ShowModel *show;
@property(nonatomic,strong)ShowView *showView;
@end
