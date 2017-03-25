//
//  Demo3WyhScrollPageBaseVC.m
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/25.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "Demo3WyhScrollPageBaseVC.h"
#import "WyhScrollPageView.h"
#import "WyhChannelManager.h"
#import "Demo3TestViewController.h"
#import "Demo3WyhSubScrollPageVC.h"
@interface Demo3WyhScrollPageBaseVC ()<WyhScrollPageDelegate>

@property (nonatomic, weak) WyhChannelManager *manager;

@property (nonatomic, strong) WyhSegmentView *segmentView;

@property (nonatomic, strong) WyhContentView *contentView;

@property (nonatomic, strong) NSMutableArray<WyhChannelModel *>* topChannelArr;

@property (nonatomic, strong) NSMutableArray<WyhChannelModel *>* bottomChannelArr;

@property (nonatomic, strong) NSMutableArray *topTitleArr;;

@end

@implementation Demo3WyhScrollPageBaseVC

+(void)initialize{
    
#if DEBUG
    
    NSLog(@"\n\
          说在前面:WyhScrollPageView是模仿ZJScrollPageView写出来的半成品 \n\
          目前正在研发中,本demo只充当示例,如果您感觉不错\n\
          可前往github搜索ZJScrollPageView,用法和如下用法基本一致");
    /**
     *   在这里给这个作者推广一下
     *   https://github.com/jasnig/ZJScrollPageView
     */
    
#endif
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self configUI];
    
    self.manager = [WyhChannelManager updateWithTopArr:self.topChannelArr BottomArr:self.bottomChannelArr InitialIndex:self.contentView.currentIndex newStyle:nil];
    
    __weak typeof(&*self) weakself = self;
    
    [WyhChannelManager updateChannelCallBack:^(NSArray<WyhChannelModel *> *top, NSArray<WyhChannelModel *> *bottom, NSUInteger chooseIndex) {
        weakself.topChannelArr = [NSMutableArray arrayWithArray:top];
        if (bottom.count!=0) {
            weakself.bottomChannelArr = [NSMutableArray arrayWithArray:bottom];
        }else{
            [weakself.bottomChannelArr removeAllObjects];
        }
        [weakself.segmentView reloadTitlesWithNewTitles:weakself.topTitleArr];
        [weakself.segmentView setSelectedIndex:chooseIndex animated:NO];
    }];
    
}

-(void)configUI{
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:@"频道管理" style:(UIBarButtonItemStyleDone) target:self action:@selector(goChannel)];
    self.navigationItem.rightBarButtonItem = right;
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.contentView];
    [self.view addSubview:self.segmentView];
}

-(void)goChannel{
    
    Demo3TestViewController *test = [Demo3TestViewController new];
    UINavigationController *navi = [[UINavigationController alloc]initWithRootViewController:test];
    [self presentViewController:navi animated:YES completion:nil];
    
}

-(WyhContentView *)contentView{
    if (!_contentView) {
        
        WyhContentView *contentView = [[WyhContentView alloc]initWithFrame:CGRectMake(0, self.segmentView.wyh_bottom, self.view.bounds.size.width, self.view.wyh_h) SegmentView:self.segmentView ParentViewController:self Delegate:self];
        _contentView = contentView;
    }
    return _contentView;
}

-(WyhSegmentView *)segmentView{
    if (!_segmentView) {
        __weak typeof(self) WeakSelf = self;
        WyhSegmentView *segmentView = [[WyhSegmentView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 40) style:nil titleArray:self.topTitleArr parentViewController:self delegate:self tapHandleBlock:^(WyhTitleView *wyhTitleLabel, NSUInteger index) {
            [WeakSelf.contentView setContentOffSet:CGPointMake(WeakSelf.contentView.bounds.size.width*index, 0) animated:NO];
        }];
        _segmentView = segmentView;
    }
    return _segmentView;
}

#pragma mark - WyhScrollPageView delegate

-(NSUInteger)wyh_numberOfChilrdVCs{
    
    return self.topChannelArr.count;
    
}

-(UIViewController<WyhScrollPageChirldVcDelegate> *)wyh_childViewController:(UIViewController<WyhScrollPageChirldVcDelegate> *)reuseChildVC ForIndex:(NSUInteger)index{
    
    Demo3WyhSubScrollPageVC *demo = (Demo3WyhSubScrollPageVC *)reuseChildVC;
    if (!demo) {
        demo = [[Demo3WyhSubScrollPageVC alloc]init];
        NSUInteger random = arc4random()%2;
        if (random == 0) {
            demo.view.backgroundColor = [UIColor yellowColor];
        }else{
            demo.view.backgroundColor = [UIColor magentaColor];
        }
    }
    
    return demo;
}

#pragma mark - lazy

-(NSMutableArray *)topTitleArr{
    
    _topTitleArr = [NSMutableArray new];
    for (WyhChannelModel *model in self.topChannelArr) {
        [_topTitleArr addObject:model.channel_name];
    }
    return _topTitleArr;
}

-(NSMutableArray<WyhChannelModel *> *)topChannelArr{
    if (!_topChannelArr) {
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"WyhChannelList" ofType:@"plist"];
        NSArray *listArr = [NSArray arrayWithContentsOfFile:path];
        
        _topChannelArr = [NSMutableArray new];
        for (int i = 0; i < 10; i++) {
            WyhChannelModel *model = [WyhChannelModel new];
            model.channel_name = listArr[i];
            model.isTop = YES;
            if ([model.channel_name isEqualToString:@"视频"]) {
                model.isHot = YES;
            }else{
                model.isHot = NO;
            }
            model.isHot = NO;
            if ([model.channel_name isEqualToString:@"头条"]) {
                model.isEnable = YES;
            }else{
                model.isEnable = NO;
            }
            [_topChannelArr addObject:model];
        }
    }
    return _topChannelArr;
}

-(NSMutableArray<WyhChannelModel *> *)bottomChannelArr{
    
    if (!_bottomChannelArr) {
        NSArray *listArr = @[@"萨德",@"现代化",@"国际"];
        _bottomChannelArr = [NSMutableArray new];
        for (int i = 0; i < listArr.count; i++) {
            WyhChannelModel *model = [WyhChannelModel new];
            model.channel_name = listArr[i];
            model.isTop = NO;
            model.isEnable = NO;
            model.isHot = NO;
            [_bottomChannelArr addObject:model];
        }
    }
    return _bottomChannelArr;
    
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
