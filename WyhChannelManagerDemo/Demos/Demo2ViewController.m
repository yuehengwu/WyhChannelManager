//
//  Demo1ViewController.m
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/24.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "Demo2ViewController.h"



#define screenWidth [UIScreen mainScreen].bounds.size.width
#define screenHeight [UIScreen mainScreen].bounds.size.height

@interface Demo2ViewController ()

@property (nonatomic, strong) NSMutableArray *top;

@property (nonatomic, strong) NSMutableArray *bottom;

@property (nonatomic, weak) WyhChannelManager *manager;

@property (nonatomic, strong) WyhChannelManagerView *managerView;

@end

@implementation Demo2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    /** 建议设置一下,不然当isShowBackCover属性为YES时,scrollView的内容会在导航栏上面 */
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self setNaviStyle];
    
    /**
     *  总体的频道管理器
     *  @param top          顶部频道数组
     *  @param bottom       底部频道数组
     *  @param initialIndex 当前选中的index
     *  @param style        当前的样式
     */
    self.manager = [WyhChannelManager updateWithTopArr:self.top BottomArr:self.bottom InitialIndex:arc4random()%20 newStyle:self.style];
    
    [self.view addSubview:self.managerView];
    
}

-(void)setNaviStyle{
    UIBarButtonItem *left1 = [[UIBarButtonItem alloc]initWithTitle:@"close" style:(UIBarButtonItemStyleDone) target:self action:@selector(closeAction:)];
    
    UIBarButtonItem *left2 = [[UIBarButtonItem alloc]initWithTitle:@"refresh" style:(UIBarButtonItemStyleDone) target:self action:@selector(refreshAction:)];
    
    self.navigationItem.leftBarButtonItems = @[left1,left2];
}


-(void)closeAction:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:^{
        /**
         *  注意务必在频道管理器消失前调用此方法进行回调频道信息
         */
        [WyhChannelManager setUpdateIfNeeds];
    }];
}

#pragma mark - demo 测试刷新变化数据

-(void)refreshAction:(id)sender{
    
    [self.top removeAllObjects];
    [self.bottom removeAllObjects];
    NSUInteger topcount1 = arc4random()%21 + 2;
    for (int i = 0; i < topcount1; i++) {
        WyhChannelModel *model = [[WyhChannelModel alloc] init];
        model.channel_name = [NSString stringWithFormat:@"新顶部%d哥",i];
        model.isTop = YES;
        if (i == arc4random()%topcount1) {
            model.isHot = YES;
        }else{
            model.isHot = NO;
        }
        [_top addObject:model];
    }
    NSUInteger topcount2 = arc4random()%21 + 2;
    for (int i = 0; i < topcount2; i++) {
        WyhChannelModel *model = [[WyhChannelModel alloc] init];
        model.channel_name = [NSString stringWithFormat:@"新底部%d哥",i];
        model.isTop = NO;
        if (i == arc4random()%topcount2) {
            model.isHot = YES;
        }else{
            model.isHot = NO;
        }
        [_bottom addObject:model];
    }
    [WyhChannelManager updateWithTopArr:self.top BottomArr:self.bottom InitialIndex:(arc4random()%topcount1) newStyle:nil];
    
    [self.managerView reloadChannels];
}

#pragma mark - lazy

-(WyhChannelManagerView *)managerView{
    if (!_managerView) {
        
        WyhChannelManagerView *channelView = [WyhChannelManagerView channelViewWithFrame:CGRectMake(0, 0, screenWidth, screenHeight-64.0) Manager:self.manager];
        _managerView = channelView;
        
        [channelView chooseChannelCallBack:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
    }
    return _managerView;
}


-(NSMutableArray *)top{
    if (!_top) {
        //virtual data
        NSMutableArray *top = [NSMutableArray new];
        for (int i = 0; i < 20; i++) {
            WyhChannelModel *model = [[WyhChannelModel alloc] init];
            model.channel_name = [NSString stringWithFormat:@"顶部%d哥",i];
            model.isTop = YES;
            if (i < 2) {
                model.isEnable = YES;
            }else{
                model.isEnable = NO;
            }
            if (i == 12) {
                model.isHot = YES;
            }else{
                model.isHot = NO;
            }
            [top addObject:model];
        }
        _top = top;
    }
    return _top;
}

-(NSMutableArray *)bottom{
    if (!_bottom) {
        NSMutableArray *bottom = [NSMutableArray new];
        //virtual data
        for (int i = 0; i < 25; i++) {
            WyhChannelModel *model = [[WyhChannelModel alloc] init];
            model.channel_name = [NSString stringWithFormat:@"底部%d哥",i];
            model.isTop = NO;
            if (i == 12) {
                model.isHot = YES;
            }else{
                model.isHot = NO;
            }
            [bottom addObject:model];
        }
        _bottom = bottom;
    }
    return _bottom;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
