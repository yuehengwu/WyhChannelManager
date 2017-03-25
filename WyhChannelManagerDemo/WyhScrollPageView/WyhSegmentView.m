//
//  WyhSegmentView.m
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/15.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhSegmentView.h"
#import "UIView+WyhExtension.m"
@interface WyhSegmentView()<UIScrollViewDelegate>



@property (nonatomic, strong) NSArray *titles;
///存放所有标题视图的数组
@property (nonatomic, strong) NSMutableArray *titleViewArr;

@property (nonatomic, strong) UIViewController *parentVC;

@property (nonatomic, weak) id<WyhScrollPageDelegate> delegate;

@property (nonatomic, copy) TapHandleBlock tapblock;

@property (nonatomic, strong) UIScrollView *scrollView;
///所有标题的宽度缓存
@property (nonatomic, strong) NSMutableArray *titleWidthArr;

@property (nonatomic, assign) CGFloat currentWidth;

@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, assign) NSUInteger oldIndex;

@end

static CGFloat const contentSizeXOff = 20.0; // 标题允许滚动的多余距离

@implementation WyhSegmentView

-(instancetype)initWithFrame:(CGRect)frame
                       style:(WyhSegmentStyle *)style
                  titleArray:(NSArray *)titles
        parentViewController:(UIViewController *)parentVC
                    delegate:(id<WyhScrollPageDelegate>)delegate
              tapHandleBlock:(TapHandleBlock)tapBlock
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.currentWidth = frame.size.width;
        self.wyhStyle = !style ? [[WyhSegmentStyle alloc]init] : style;
        self.titles = titles;
        self.delegate = delegate;
        self.parentVC = parentVC;
        self.tapblock = tapBlock;
        self.currentIndex = 0; /* 默认的索引*/
        
        [self setupSubViews];
    }
    return self;
}

-(void)setupSubViews{
    
    if (![self.subviews containsObject:self.scrollView]) {
        [self setupScrollView];
    }
    [self setupTitleViewsPosition];
    [self setupScrollBar];
    
}

-(void)setTitles:(NSArray *)titles{
    
    if (_titles != titles) {
        _titles = titles;
        
        NSInteger index = 0;
        for (NSString *title in self.titles) {
            
            WyhTitleView *titlelabel = [[WyhTitleView alloc]initWithFrame:CGRectZero];
            
            titlelabel.font = self.wyhStyle.font;
            
            titlelabel.text = title;
            
            titlelabel.tag = index;
            
            UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapHandleRecognizer:)];
            
            [titlelabel addGestureRecognizer:tapGes];
            
            [self.scrollView addSubview:titlelabel];
            
            [self.titleViewArr addObject:titlelabel];
            [self.titleWidthArr addObject:@(titlelabel.labelSize.width)];
            
            index++;
        }
        
    }
}
-(void)setupScrollView{
    
    self.backgroundColor = [UIColor whiteColor];
    
    self.scrollView.frame = CGRectMake(0, 0, self.currentWidth, self.bounds.size.height);
    [self addSubview:self.scrollView];
}

-(void)setupTitleViewsPosition{
    
    if (!self.wyhStyle.isShowScrollBar) {
        self.wyhStyle.scrollBarHeight = 0;
    }
    
    CGFloat titleX;
    CGFloat titleY;
    CGFloat titleW;
    CGFloat titleH = self.bounds.size.height - self.wyhStyle.scrollBarHeight;
    
    if (!self.wyhStyle.isScrollTitle) {
        NSInteger index = 0;
        for (WyhTitleView *titlelabel in self.titleViewArr) {
            
            titlelabel.viewHeight = titleH;
            
            titleW = self.bounds.size.width*1.f/self.titles.count*1.f;
            
            titleX = titleW*index;
            titleY = 0;
            
            titlelabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
            
            [titlelabel adjustSubViewsWithStyle:self.wyhStyle];
            
            index ++;
        }
    }else {
        NSInteger index = 0;
        float lastLableMaxX = self.wyhStyle.titleMargin;
        float addedMargin = 0.0f; /* 标题相对于左侧额外的间隔*/
        if (self.wyhStyle.isAutoAdjustTitlesWidth) {
            
            float allTitlesWidth = self.wyhStyle.titleMargin; /* 只相对于当标题左右间隔和标题之间的间隔相等时*/
            
            for (int i = 0; i<self.titleWidthArr.count; i++) {
                allTitlesWidth = allTitlesWidth + [self.titleWidthArr[i] floatValue] + self.wyhStyle.titleMargin;
            }
            
            addedMargin = allTitlesWidth < self.scrollView.bounds.size.width ? (self.scrollView.bounds.size.width - allTitlesWidth)/self.titleWidthArr.count : 0 ;
        }
        
        for (WyhTitleView *titleView in self.titleViewArr) {
            titleW = [self.titleWidthArr[index] floatValue];
            titleX = lastLableMaxX + addedMargin/2;
            
            lastLableMaxX += (titleW + addedMargin + self.wyhStyle.titleMargin);
            
            titleView.frame = CGRectMake(titleX, titleY, titleW, titleH);
            
            titleView.viewHeight = titleH;
            
            [titleView adjustSubViewsWithStyle:self.wyhStyle];
            
            index++;
        }
    }
    if (_currentIndex >= self.titleViewArr.count) {
        _currentIndex = self.titleViewArr.count - 1;
    }
    //设置当前View的初始化样式
    WyhTitleView *firstView = self.titleViewArr[_currentIndex];
    if (firstView) {
        
        firstView.textColor = self.wyhStyle.selectTitleColor;
        firstView.currentTransformX = self.wyhStyle.titleMaxScale;
    }
    
    // 设置滚动区域
    if (self.wyhStyle.isScrollTitle) {
        WyhTitleView *lastTitleView = (WyhTitleView *)self.titleViewArr.lastObject;
        
        if (lastTitleView) {
            self.scrollView.contentSize = CGSizeMake(CGRectGetMaxX(lastTitleView.frame) + contentSizeXOff, 0.0);
        }
    }
    
    
    
}

-(void)setupScrollBar{
    
    WyhSegmentStyle *style = self.wyhStyle;
    
    if (!style.isShowScrollBar)  return;

    WyhTitleView *currentTitleView = self.titleViewArr[_currentIndex];
    
//    titlelabel.viewHeight = self.bounds.size.height - self.wyhStyle.scrollBarHeight;
//    
//    titlelabel.textColor = self.wyhStyle.selectTitleColor;
    
    self.scrollBar.frame = currentTitleView.scrollBarFrame;
    
    if (self.wyhStyle.scrollBarWidth!=0) {
        self.scrollBar.wyh_x = (currentTitleView.wyh_x - self.wyhStyle.scrollBarWidth)/2.0;
        self.scrollBar.wyh_w = self.wyhStyle.scrollBarWidth;
    }else {
        
        self.scrollBar.wyh_x = currentTitleView.wyh_x;
        self.scrollBar.wyh_w = currentTitleView.wyh_w;
        
    }
    
    [self.scrollView addSubview:self.scrollBar];
    
    
}

#pragma mark - tap handle

-(void)tapHandleRecognizer:(UITapGestureRecognizer *)tapGes{
    
    WyhTitleView *titleView = (WyhTitleView *)tapGes.view;
    
    _currentIndex = titleView.tag;
    
    [self adjustUIWhenBtnOnClickWithAnimate:YES taped:YES];
    
    
    
}


#pragma mark - segmentView publick

-(void)reloadTitlesWithNewTitles:(NSArray *)titles{
    
    
    
    [self.scrollView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.titleViewArr = nil;
    self.titles = nil;
    self.titleWidthArr = nil;
    self.titles = [titles copy];
    if (titles.count == 0) return;
    
    if (_oldIndex >= self.titles.count) {
        _oldIndex = 0;
    }    
    
    [self setupSubViews];
}

-(void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated{
    
    NSAssert(index >= 0 && index < self.titles.count, @"设置的下标不合法!!");
    
    if (index < 0 || index >= self.titles.count) {
        return;
    }
    
    _currentIndex = index;
    
    [self adjustUIWhenBtnOnClickWithAnimate:animated taped:NO];
    
}

- (void)adjustUIWhenBtnOnClickWithAnimate:(BOOL)animated taped:(BOOL)taped{
    if (_currentIndex == _oldIndex && taped) { return; }
    
    WyhTitleView *oldTitleView = (WyhTitleView *)self.titleViewArr[_oldIndex];
    WyhTitleView *currentTitleView = (WyhTitleView *)self.titleViewArr[_currentIndex];
    
    CGFloat animatedTime = animated ? 0.30 : 0.0;
    
    __weak typeof(self) weakSelf = self;
    
    [UIView animateWithDuration:animatedTime animations:^{
        oldTitleView.textColor = weakSelf.wyhStyle.normalTitleColor;
        currentTitleView.textColor = weakSelf.wyhStyle.selectTitleColor;
        if (weakSelf.wyhStyle.isScaleTitle) {
            oldTitleView.currentTransformX = 1.0f;
            currentTitleView.currentTransformX = weakSelf.wyhStyle.titleMaxScale;
        }
        
        if (weakSelf.scrollBar) {
            if (weakSelf.wyhStyle.isScrollTitle) {
                
                if (self.wyhStyle.scrollBarWidth!=0) {
                    weakSelf.scrollBar.wyh_x = (currentTitleView.wyh_x - self.wyhStyle.scrollBarWidth)/2.0;
                    weakSelf.scrollBar.wyh_w = weakSelf.wyhStyle.scrollBarWidth;
                }else {
                    
                    weakSelf.scrollBar.wyh_x = currentTitleView.wyh_x;
                    weakSelf.scrollBar.wyh_w = currentTitleView.wyh_w;
                
                }
            } else {
//                if (self.segmentStyle.isAdjustCoverOrLineWidth) {
//                    CGFloat scrollLineW = [self.titleWidths[_currentIndex] floatValue] + wGap;
//                    CGFloat scrollLineX = currentTitleView.zj_x + (currentTitleView.zj_width - scrollLineW) * 0.5;
//                    weakSelf.scrollLine.zj_x = scrollLineX;
//                    weakSelf.scrollLine.zj_width = scrollLineW;
//                } else {
//                    weakSelf.scrollLine.zj_x = currentTitleView.zj_x;
//                    weakSelf.scrollLine.zj_width = currentTitleView.zj_width;
//                }
                
            }
        }
    } completion:^(BOOL finished) {
        [weakSelf adjustUIWhenDidEndDragToCurrentIndex:_currentIndex];
        
    }];
    
    _oldIndex = _currentIndex;
    if (self.tapblock) {
        self.tapblock(currentTitleView,_currentIndex);
    }
}

-(void)adjustUIWithProgress:(CGFloat)progress OldIndex:(NSInteger)oldIndex CurrentIndex:(NSInteger)currentIndex{
    
    if (oldIndex < 0 ||
        oldIndex >= self.titles.count ||
        currentIndex < 0 ||
        currentIndex >= self.titles.count
        ) {
        return;
    }
    _oldIndex = currentIndex;
    
    WyhTitleView *oldTitleView = (WyhTitleView *)self.titleViewArr[oldIndex];
    WyhTitleView *currentTitleView = (WyhTitleView *)self.titleViewArr[currentIndex];
    
    
    CGFloat xDistance = currentTitleView.wyh_x - oldTitleView.wyh_x;
    CGFloat wDistance = currentTitleView.wyh_w - oldTitleView.wyh_w;
    
    if (self.scrollBar && self.wyhStyle.isBarMoveWhenScrolled) {
        
        self.scrollBar.wyh_x = oldTitleView.wyh_x + xDistance * progress;
        self.scrollBar.wyh_w = oldTitleView.wyh_w + wDistance * progress;
        
    }
    
    if (!self.wyhStyle.isScrollTitle) return;
        
    CGFloat deltaScale = self.wyhStyle.titleMaxScale - 1.0;
    oldTitleView.currentTransformX = self.wyhStyle.titleMaxScale - deltaScale * progress;
    currentTitleView.currentTransformX = 1.0 + deltaScale * progress;
    
}

-(void)adjustUIWhenDidEndDragToCurrentIndex:(NSUInteger)currentIndex{
    
//    _oldIndex = currentIndex;
    
//    NSLog(@"old:%ld new:%ld",oldIndex,currentIndex);
    
    WyhTitleView *currentView = (WyhTitleView *)self.titleViewArr[currentIndex];
    
    [self.titleViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
       
        WyhTitleView *objc = obj;
        
        if (idx == currentIndex) {
            objc.textColor = self.wyhStyle.selectTitleColor;
            objc.currentTransformX = self.wyhStyle.isScaleTitle?self.wyhStyle.titleMaxScale:1.0;
        }else {
            objc.textColor = self.wyhStyle.normalTitleColor;
            objc.currentTransformX = 1.0f;
        }
        
    }];
    
    // 标题居中
    if (self.scrollView.contentSize.width != self.scrollView.bounds.size.width + contentSizeXOff) {// 需要滚动
        WyhTitleView *currentTitleView = (WyhTitleView *)_titleViewArr[currentIndex];
        
        CGFloat offSetx = currentTitleView.center.x - _currentWidth * 0.5;
        if (offSetx < 0) {
            offSetx = 0;
            
        }
        //        CGFloat extraBtnW = self.extraBtn ? self.extraBtn.zj_width : 0.0;
        CGFloat maxOffSetX = self.scrollView.contentSize.width - (_currentWidth); // -extraBtnW
        
        if (maxOffSetX < 0) {
            maxOffSetX = 0;
        }
        
        if (offSetx > maxOffSetX) {
            offSetx = maxOffSetX;
        }
        
        [self.scrollView setContentOffset:CGPointMake(offSetx, 0.0) animated:YES];
        
        if (self.scrollBar && !self.wyhStyle.isBarMoveWhenScrolled) {
            
            [UIView animateWithDuration:0.3 animations:^{
                
                self.scrollBar.wyh_x = currentView.frame.origin.x - offSetx;
                
                self.scrollBar.wyh_w = currentView.scrollBarFrame.size.width;
                
            } completion:^(BOOL finished) {
                
            }];
        }
    }
}
#pragma mark - Lazy
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc]init];
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.scrollsToTop = NO;
        scrollView.bounces = self.wyhStyle.isBounces;
        scrollView.pagingEnabled = NO;
        scrollView.delegate = self;
        _scrollView = scrollView;
    }
    return _scrollView;
}

-(NSMutableArray *)titleWidthArr{
    if (!_titleWidthArr) {
        _titleWidthArr = [NSMutableArray new];
    }
    return _titleWidthArr;
}

-(NSMutableArray *)titleViewArr{
    if (!_titleViewArr) {
        _titleViewArr = [NSMutableArray new];
    }
    return _titleViewArr;
}

-(UIView *)scrollBar{
    if (!self.wyhStyle.isShowScrollBar) {
        return nil;
    }
    if (!_scrollBar) {
        _scrollBar = [[UIView alloc]initWithFrame:CGRectZero];
        _scrollBar.backgroundColor = self.wyhStyle.scrollBarColor;
    }
    return _scrollBar;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
