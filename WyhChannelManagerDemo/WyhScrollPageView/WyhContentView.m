//
//  WyhContentView.m
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/15.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhContentView.h"
#import "UIViewController+WyhScrollPageController.h"
#import "UIView+WyhExtension.h"

@interface WyhContentView()<UICollectionViewDelegate,UICollectionViewDataSource>
///数据源
@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, weak) WyhSegmentView *segmentView;

@property (nonatomic, strong) WyhCollectionView *collectionView;

@property (nonatomic, weak) UIViewController *parentViewController;

@property (nonatomic, strong) UIViewController <WyhScrollPageChirldVcDelegate> *currentChildVC;

@property (strong, nonatomic) UICollectionViewFlowLayout *collectionViewLayout;

@property (nonatomic, weak) id<WyhScrollPageDelegate> delegate;

@property (nonatomic, assign) CGFloat oldOffSetX;

@property (nonatomic, assign) NSUInteger oldIndex;

@property (nonatomic, assign) NSUInteger currentIndex;

///所有的子控制器字典(需要遵守WyhScrollPageChirldVcDelegate协议)
@property (strong, nonatomic) NSMutableDictionary<NSString *, UIViewController<WyhScrollPageChirldVcDelegate> *> *childVcsDic;

@end


@implementation WyhContentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(instancetype)initWithFrame:(CGRect)frame
                 SegmentView:(WyhSegmentView *)segment
        ParentViewController:(UIViewController *)parentVC
                    Delegate:(id<WyhScrollPageDelegate>) delegate{
    
    NSAssert(delegate!=nil, @"WyhContentView 必须设置代理人");
    
    if (self = [super initWithFrame:frame]) {
        
        _segmentView = segment;
        
        _parentViewController = parentVC;
        
        _delegate = delegate;
        
        [self updateConstraints];
    }
    return self;
}

#pragma mark - updateConstraints

-(void)updateConstraints{
    
    [super updateConstraints];
    
    [self addSubview:self.collectionView];
}

#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView.contentOffset.x<=0 || scrollView.contentOffset.x>= scrollView.contentSize.width - scrollView.bounds.size.width) {/*判断是第一个或者最后一个*/
        return;
    }
    CGFloat tempProgress = scrollView.contentOffset.x / self.bounds.size.width;
    NSInteger tempIndex = tempProgress;
    
    CGFloat progress = tempProgress - floor(tempProgress);
    CGFloat deltaX = scrollView.contentOffset.x - _oldOffSetX;
    
    if (deltaX > 0) {// 向右
        if (progress == 0.0) {
            return;
        }
        self.currentIndex = tempIndex+1;
        self.oldIndex = tempIndex;
    }
    else if (deltaX < 0) {
        progress = 1.0 - progress;
        self.oldIndex = tempIndex+1;
        self.currentIndex = tempIndex;
        
    }
    else {
        return;
    }
//    CGFloat currentPositionf = scrollView.contentOffset.x / self.bounds.size.width;
//    
//    NSInteger currentPositionInt = currentPositionf;
//    
////    CGFloat progress = currentPositionf - floor(currentPositionf);/*暂时用不到*/
//    
//    CGFloat deltaX = scrollView.contentOffset.x - _oldOffSetX;
//    
//    if (deltaX > 0) { /*向右滑动*/
//        self.currentIndex = currentPositionInt + 1;
//        self.oldIndex = currentPositionInt;
//    }else if(deltaX < 0){
//        
//        self.currentIndex = currentPositionInt;
//        self.oldIndex = currentPositionInt + 1;
//    }else{
//        return;
//    }
    if (self.segmentView) {
        [self.segmentView adjustUIWithProgress:progress OldIndex:_oldIndex CurrentIndex:_currentIndex];
    }
//    NSLog(@"旧位置：%ld 新位置：%ld",_oldIndex,_currentIndex);
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    _oldOffSetX = scrollView.contentOffset.x;
    
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    
    NSInteger currentIndex = (scrollView.contentOffset.x / self.bounds.size.width);
    
    if (self.segmentView) {
        
        [self.segmentView adjustUIWithProgress:1.0 OldIndex:_oldIndex CurrentIndex:_currentIndex];
        
        [self.segmentView adjustUIWhenDidEndDragToCurrentIndex:currentIndex];
    }
    
}

#pragma mark - CollectionView Delegate and DataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.delegate wyh_numberOfChilrdVCs];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellReuserIndentifier forIndexPath:indexPath];
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];/* 移除subviews 避免重用内容显示错误*/
    
    if (WYH_iOSVersion < 8.0) {
        
        [self setupContentViewFromChildvcForCell:cell atIndexPath:indexPath];
    }
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    if (WYH_iOSVersion >= 8.0) {

        [self setupContentViewFromChildvcForCell:cell atIndexPath:indexPath];/*请确保iOS8以上版本使用*/
    }
    
}



#pragma mark - private fuction

-(void)setupContentViewFromChildvcForCell:(UICollectionViewCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(wyh_childViewController:ForIndex:)]) {
        
        self.currentChildVC = [self.childVcsDic objectForKey:[NSString stringWithFormat:@"%ld",indexPath.row]];/*从缓存里拿*/
        
        if (!self.currentChildVC) {
            
            self.currentChildVC = [self.delegate wyh_childViewController:self.currentChildVC ForIndex:indexPath.row];
            
            NSAssert(self.currentChildVC,@"子控制器未捕捉到");
            
            NSAssert([self.currentChildVC conformsToProtocol:@protocol(WyhScrollPageChirldVcDelegate)], @"子控制器必须遵守协议代理");
            
            self.currentChildVC.wyh_currentIndex = indexPath.row;/*设置下标*/
            
            [self.childVcsDic setValue:self.currentChildVC forKey:[NSString stringWithFormat:@"%ld",indexPath.row]];/*缓存控制器*/
        }else{
            
            /*已添加过，不作处理*/
            [self.delegate wyh_childViewController:self.currentChildVC ForIndex:indexPath.row];
            
        }
        if (self.currentChildVC.wyh_scrollViewController != self.parentViewController) {
            
            [self.parentViewController addChildViewController:self.currentChildVC];
        }
        
        self.currentChildVC.view.frame = self.bounds;
        
        [cell.contentView addSubview:self.currentChildVC.view];
        
        [self.currentChildVC didMoveToParentViewController:self.parentViewController];

    }
}

#pragma mark - public function

-(void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated{
    
    NSInteger currentIndex = offset.x/self.collectionView.bounds.size.width;
    _oldIndex = _currentIndex;
    self.currentIndex = currentIndex;
    if (animated) {
        CGFloat delta = offset.x - self.collectionView.contentOffset.x;
        NSInteger page = fabs(delta)/self.collectionView.bounds.size.width;
        if (page>=2) {// 需要滚动两页以上的时候, 跳过中间页的动画
            __weak typeof(self) weakself = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                __strong typeof(weakself) strongSelf = weakself;
                if (strongSelf) {
                    [strongSelf.collectionView setContentOffset:offset animated:NO];
                }
            });
        }
        else {
            [self.collectionView setContentOffset:offset animated:animated];
        }
    }
    else {
        
        [self.collectionView setContentOffset:offset animated:animated];
        
    }
}


#pragma mark - Lazy

- (UICollectionViewFlowLayout *)collectionViewLayout {
    if (_collectionViewLayout == nil) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = self.bounds.size;
        layout.minimumLineSpacing = 0.0;
        layout.minimumInteritemSpacing = 0.0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _collectionViewLayout = layout;
    }
    
    return _collectionViewLayout;
}

- (WyhCollectionView *)collectionView {
    if (!_collectionView) {
        WyhCollectionView *collectionView = [[WyhCollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.collectionViewLayout];
        [collectionView setBackgroundColor:[UIColor whiteColor]];
        collectionView.pagingEnabled = YES;
        collectionView.scrollsToTop = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:cellReuserIndentifier];
        collectionView.bounces = NO;
        
        _collectionView = collectionView;
    }
    return _collectionView;
}

-(NSMutableDictionary<NSString *,UIViewController<WyhScrollPageChirldVcDelegate> *> *)childVcsDic{
    if (!_childVcsDic) {
        _childVcsDic = [NSMutableDictionary new];
    }
    return _childVcsDic;
}

@end
