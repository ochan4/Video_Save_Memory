//
//  ViewController.m
//  test
//
//  Created by jc on 16/5/30.
//  Copyright © 2016年 Tarena. All rights reserved.
//

#import "ViewController.h"
#import "DuanTableViewCell.h"
#import "ShowModel.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView* tableView;
//存放数据模型的数组
@property(strong,nonatomic)NSMutableArray *tableData;
//计算cell的高度
@property(nonatomic,assign)CGFloat cellHeight;
//用于加载下一页的参数(页码)
@property (nonatomic,assign) NSInteger currentPage;

@end

@implementation ViewController
#pragma mark - 全局常量
static NSString *apiID = @"19882";
static NSString *apiSign = @"c0b134be7ee64269a4b8b9ff6670188a";

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setupTableView];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
}

#pragma mark - UITableviewDatasource 数据源方法

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellHeight;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DuanTableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [self appearCell:cell andScale:2];
    
    cell.show = self.tableData[indexPath.row];
    
    self.cellHeight = cell.frame.size.height;
    
    return cell;
}

#pragma mark - UITableviewDelegate 代理方法

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - 刷新cell时动画加载

- (void)appearCell:(UITableViewCell *)cell andScale:(CGFloat)scale
{
    CATransform3D rotate = CATransform3DMakeScale( 0.0, scale, scale);
    cell.layer.shadowColor = [UIColor blackColor].CGColor;
    cell.layer.shadowOffset = CGSizeMake(10, 10);
    cell.alpha = 0;
    cell.layer.transform = rotate;
    [UIView beginAnimations:@"scale" context:nil];
    [UIView setAnimationDuration:.3];
    cell.layer.transform = CATransform3DIdentity;
    cell.alpha = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 0);
    [UIView commitAnimations];
    cell.backgroundColor = [UIColor clearColor];
}

#pragma mark - 请求数据方法

//上拉刷新 发送请求并获取数据方法
- (void)loadData{
    
    NSString *path = [NSString stringWithFormat:@"http://route.showapi.com/255-1?showapi_appid=%@&showapi_sign=%@&page=%ld",apiID,apiSign,self.currentPage];
    
    NSURL * url = [NSURL URLWithString:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSData* plistData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *mainDic = [NSJSONSerialization JSONObjectWithData:plistData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *showapi_res_body = mainDic[@"showapi_res_body"];
    
    NSDictionary *pagebean = showapi_res_body[@"pagebean"];
    
    NSArray *contentlist = pagebean[@"contentlist"];
    
    if (mainDic) {
        for (NSDictionary *dic in contentlist) {
            
            ShowModel *show = [ShowModel new];
            
            if (dic[@"image0"]) {
                
                show.imagePath = dic[@"image0"];
                
            }else if (dic[@"video_uri"]) {
                
                show.video_uri = dic[@"video_uri"];            
            }
            show.content = dic[@"text"];
            show.love = [NSString stringWithFormat:@" %@",dic[@"love"]];
            show.hate = [NSString stringWithFormat:@" %@",dic[@"hate"]];
            show.create_time = dic[@"create_time"];
            
            if ([self.tableData count]!=20) {
                [self.tableData addObject:show];
            }

            // 刷新数据（若不刷新数据会显示不出）
            [self.tableView reloadData];
            [self.tableView.mj_header endRefreshing];
            
        }
    }else{
        
        NSLog(@"onError");
        
        [self.tableView.mj_header endRefreshing];
        
    }
    
}

//下拉加载 更新页码并获取数据方法
- (void)loadMoreData{
    
    NSString *path = [NSString stringWithFormat:@"http://route.showapi.com/255-1?showapi_appid=%@&showapi_sign=%@&page=%ld",apiID,apiSign,++self.currentPage];
    
    NSURL * url = [NSURL URLWithString:[path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]]];
    
    NSString *str = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:nil];
    
    NSData* plistData = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *mainDic = [NSJSONSerialization JSONObjectWithData:plistData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *showapi_res_body = mainDic[@"showapi_res_body"];
    
    NSDictionary *pagebean = showapi_res_body[@"pagebean"];
    
    NSArray *contentlist = pagebean[@"contentlist"];
    
    if (mainDic) {
        
        for (NSDictionary *dic in contentlist) {
            
            ShowModel *show = [ShowModel new];
            
            if (dic[@"image0"]) {
                
                show.imagePath = dic[@"image0"];
                
            }else if (dic[@"video_uri"]) {
                
                show.video_uri = dic[@"video_uri"];
                
            }
            show.content = dic[@"text"];
            show.love = [NSString stringWithFormat:@" %@",dic[@"love"]];
            show.hate = [NSString stringWithFormat:@" %@",dic[@"hate"]];
            show.create_time = dic[@"create_time"];
            
            [self.tableData addObject:show];
            
            // 刷新数据（若不刷新数据会显示不出）
            [self.tableView reloadData];
            [self.tableView.mj_footer endRefreshing];
        }
        
    }else{
        
        NSLog(@"onError");
        
        [self.tableView.mj_footer endRefreshing];
        
    }

}

#pragma mark - 页面初始化加载

-(void)setupTableView{
    
    self.currentPage = 1;
    
    self.tableData = [NSMutableArray array];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.bounds];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[DuanTableViewCell class] forCellReuseIdentifier:@"cell"];
    _tableView.backgroundColor = [UIColor clearColor];
    
    // 头部刷新控件
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadData)];
    [self.tableView.mj_header beginRefreshing];
    
    // 尾部刷新控件
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
}
@end
