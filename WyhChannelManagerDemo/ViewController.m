//
//  ViewController.m
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/22.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "ViewController.h"
#import "WyhChannelManager.h"
#import "Demo1ViewController.h"
#import "Demo2ViewController.h"
#import "Demo3WyhScrollPageBaseVC.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *list;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *logo;

@property (nonatomic, strong) UILabel *topLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UILabel *topCountLabel;

@property (nonatomic, strong) UILabel *bottomCountLabel;

@property (nonatomic, strong) UILabel *selectCountLabel;

@property (nonatomic, strong) UILabel *selectLabel;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[@"*普通边框显示频道",@"*自定义顶部和底部频道图案",@"*移动频道显示占位图",@"*自定义大背景图",@"*前两个频道固定不可编辑",@"*模拟实际频道运用,务必要看"].mutableCopy;
    
    [self resetManagerCallBack];
    
    [self.view addSubview:self.tableView];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"重置" style:(UIBarButtonItemStyleDone) target:self action:@selector(resetManagerCallBack)];
    
}

-(void)resetManagerCallBack{
    
    self.topCountLabel.text = @"0";
    self.bottomCountLabel.text = @"0";
    self.selectCountLabel.text = @"0";
    
    [WyhChannelManager updateChannelCallBack:^(NSArray<WyhChannelModel *> *top, NSArray<WyhChannelModel *> *bottom, NSUInteger chooseIndex) {
        
        self.selectCountLabel.text = [NSString stringWithFormat:@"%ld",chooseIndex];
        
        NSUInteger idx = 0;
        for (WyhChannelModel *model in top) {
            NSLog(@"回调上数组:%@,选中的index:%ld",[model description],chooseIndex);
            if (idx==top.count-1) {
                self.topCountLabel.text = [NSString stringWithFormat:@"%ld",top.count];
            }
            idx++;
        }
        
        NSUInteger index = 0;
        for (WyhChannelModel *model in bottom) {
            NSLog(@"回调下数组:%@,选中的index:%ld",[model description],chooseIndex);
            if (index==bottom.count-1) {
                self.bottomCountLabel.text = [NSString stringWithFormat:@"%ld",bottom.count];
            }
            index++;
        }
        
    }];

    
}

#pragma mark - delegate 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.list.count;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"cell"];
    }
    cell.textLabel.text = self.list[indexPath.row];
    cell.selectionStyle = 0;
    
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    WyhChannelStyle *style = [[WyhChannelStyle alloc]init];
    
    switch (indexPath.row) {
        case 0:
        {
            Demo1ViewController *demo = [[Demo1ViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:demo];
            demo.style = nil;
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 1:
        {
            Demo1ViewController *demo = [[Demo1ViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:demo];
            style.selectedTextColor = [UIColor purpleColor];
            style.isShowCover = YES;
            style.isShowBorder = NO;
            style.coverTopImage = [UIImage imageNamed:@"pindao_btn_reduce"];
            style.coverBottomImage = [UIImage imageNamed:@"pindao_btn_add"];
            demo.style = style;
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 2:
        {
            Demo1ViewController *demo = [[Demo1ViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:demo];
            style.selectedTextColor = [UIColor greenColor];
            style.isShowPlaceHolderView = YES;
            demo.style = style;
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 3:
        {
            Demo1ViewController *demo = [[Demo1ViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:demo];
            style.normalTextColor = [UIColor whiteColor];
            style.isShowBackCover = YES;
            style.selectedTextColor = [UIColor blueColor];
            demo.style = style;
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 4:
        {
            Demo2ViewController *demo = [[Demo2ViewController alloc]init];
            UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:demo];
            demo.style = nil;
            [self presentViewController:navi animated:YES completion:nil];
        }
            break;
        case 5:
        {
            Demo3WyhScrollPageBaseVC *demo = [[Demo3WyhScrollPageBaseVC alloc]init];
            [self.navigationController pushViewController:demo animated:YES];
        }
            break;
        default:
            break;
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
}

#pragma mark - lazy

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, screenWidth, screenHeight) style:(UITableViewStylePlain)];
        _tableView.delegate= self;
        _tableView.dataSource = self;
        _tableView.tableHeaderView = self.logo;
    }
    return _tableView;
}

-(UIImageView *)logo{
    if (!_logo) {
        _logo = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo"]];
        _logo.frame = CGRectMake(0, 0, screenWidth,screenWidth);
        [_logo addSubview:self.topLabel];
        [_logo addSubview:self.bottomLabel];
        [_logo addSubview:self.topCountLabel];
        [_logo addSubview:self.bottomCountLabel];
        [_logo addSubview:self.selectLabel];
        [_logo addSubview:self.selectCountLabel];
    }
    return _logo;
}

-(UILabel *)topLabel{
    if (!_topLabel) {
        _topLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 20, 150, 20)];
        _topLabel.textColor = [UIColor whiteColor];
        _topLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _topLabel.text = @"顶部频道个数:";
    }
    return _topLabel;
}

-(UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, screenWidth - 40, 150, 20)];
        _bottomLabel.textColor = [UIColor whiteColor];
        _bottomLabel.font = [UIFont boldSystemFontOfSize:15.0f];
        _bottomLabel.text = @"底部频道个数:";
    }
    return _bottomLabel;
}

-(UILabel *)bottomCountLabel{
    if (!_bottomCountLabel) {
        _bottomCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, screenWidth - 160, 120, 120)];
        _bottomCountLabel.textAlignment = NSTextAlignmentCenter;
        _bottomCountLabel.textColor = [UIColor whiteColor];
        _bottomCountLabel.text = @"0";
        _bottomCountLabel.font = [UIFont boldSystemFontOfSize:80.0f];
    }
    return _bottomCountLabel;
}

-(UILabel *)topCountLabel{
    if (!_topCountLabel) {
        _topCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, self.topLabel.frame.origin.y + self.topLabel.frame.size.height, 120, 120)];
        _topCountLabel.textAlignment = NSTextAlignmentCenter;
        _topCountLabel.textColor = [UIColor whiteColor];
        _topCountLabel.text = @"0";
        _topCountLabel.font = [UIFont boldSystemFontOfSize:80.0f];
    }
    return _topCountLabel;
}

-(UILabel *)selectLabel{
    if (!_selectLabel) {
        
        _selectLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 100, self.selectCountLabel.frame.origin.y - 20, 120, 20)];
        _selectLabel.textColor = [UIColor whiteColor];
        _selectLabel.font = [UIFont systemFontOfSize:15.0f];
        _selectLabel.text = @"选中的频道:";
        
    }
    return _selectLabel;
}

-(UILabel *)selectCountLabel{
    
    if (!_selectCountLabel) {
        _selectCountLabel = [[UILabel alloc]initWithFrame:CGRectMake(screenWidth - 120, screenWidth/2-60, 120, 120)];
        _selectCountLabel.textAlignment = NSTextAlignmentCenter;
        _selectCountLabel.textColor = [UIColor whiteColor];
        _selectCountLabel.text = @"0";
        _selectCountLabel.font = [UIFont boldSystemFontOfSize:100.0f];
    }
    return _selectCountLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
