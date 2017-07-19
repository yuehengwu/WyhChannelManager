//
//  WyhChannelManagerView.m
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/22.
//  Copyright © 2017年 wyh. All rights reserved.
//


#import "WyhChannelManager.h"

@interface WyhChannelManagerView()

/** 频道管理器 */
@property (nonatomic, strong) WyhChannelManager *manager;
/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editBtn;
/** scrollView */
@property (nonatomic, strong) UIScrollView *scrollView;
/** 顶部频道WyhChannelView数组 */
@property (nonatomic, strong) NSMutableArray *topViewArr;
/** 底部频道WyhChannelView数组 */
@property (nonatomic, strong) NSMutableArray *bottomViewArr;
/** 大背景视图 */
@property (nonatomic, strong) UIImageView *coverImageView;
/** 占位的view */
@property (nonatomic, strong) UIImageView *placeHolderView;
/** 移动前旧位置模型 */
@property (nonatomic, strong) WyhChannelModel *oldModel;
/** 当前频道所在的view */
@property (nonatomic, strong) WyhChannelView *initialView;
/** 旧位置 */
@property (nonatomic, assign) NSUInteger oldIndex;
/** 当前位置 */
@property (nonatomic, assign) NSUInteger currentIndex;
/** 编辑模式 */
@property (nonatomic, assign) BOOL isEdit;
/** 顶部提示的view */
@property (nonatomic, strong) UIView *topTipView;
/** 底部提示的view */
@property (nonatomic, strong) UIView *bottomTipView;
/** 选中某一频道的回调事件,由于逻辑层已在manager中处理,此处不再做处理 */
@property (nonatomic, copy) void(^chooseChannelHandle)();

/** @!已弃用
 *  改为对model中isEnable属性做判断
 *  注意如果你希望将某些频道默认置顶不可移动编辑,请index值添加到此数组里 */
//@property (nonatomic, strong) NSArray<NSNumber *> *enableIdxArr;

@end

@implementation WyhChannelManagerView

static CGFloat viewWidth;                   //当前宽度
static CGFloat viewHeight;                  //当期高度
static UIColor *scrollViewBackgroundColor;  //scrollView的背景色
static UIImage *coverImage;                 //底部图片
static CGFloat edgeX;                       //channelView的左右边距
static CGFloat topY;                        //第一行channelView距离顶部距离
static CGFloat spaceX;                      //channelView之间x的间隔
static CGFloat spaceY;                      //channelView之间y的间隔
static NSUInteger numberOfLine;             //一行有几个channelView
static CGFloat channelW;                    //channelView的宽度
static CGFloat channelH;                    //channelView的高度
static UIImage *placeHolderImage;           //透明占位View的图片
static BOOL isShowBackCover;                //是否显示最底部coverView
static BOOL isLongTapScale;                 //是否长按放大
static BOOL isShowPlaceHolderView;          //是否展示透明占位View
static BOOL isShowSlectedColor;             //是否显示选中view的颜色
static BOOL isScrollViewBounces;            //频道界面是否有回弹效果


#pragma mark - initialize

+(void)initialize{
    
#if DEBUG
    NSLog(@"\n\
          友情提示:如果你希望修改WyhChannelManagerView频道管理视图的布局样式 \n\
          请直接修改WyhChannelManagerView.m里面的static常量 \n\
          若希望自定义则建议使用WyhChannelStyle进行修改样式 \n\
          目前样式全部从WyhChannelStyle中取 \n\
          具体属性含义请前往WyhChannelManager.h中查看 \n\
          由于作者比较懒惰,并没有将所有样式封装到WyhChannelStyle里 望海涵\n");
#endif
    
}

-(void)initialize {
    
    /** 
     *  如果你发现有更好的处理方式或者更多样化的样式需求
     *  请联系我:
     *  QQ:  609223770@qq.com
     *  简书: http://www.jianshu.com/u/b76e3853ae0b
     */
    
    viewWidth = self.bounds.size.width;
    viewHeight = self.bounds.size.height;
    scrollViewBackgroundColor = [UIColor whiteColor];
    coverImage = [UIImage imageNamed:@"backCover"];       //请自定义
    placeHolderImage = [UIImage imageNamed:@"channel_bg"];//请自定义
    edgeX = 15.f;
    spaceX = 10.0;
    spaceY = 0.0;
    topY = 50.0;
    numberOfLine = 3;
    channelW = floorf((viewWidth - 2*edgeX - (numberOfLine-1)*spaceX)/numberOfLine);
    channelH = channelW*1.f/2.f;
    isLongTapScale = YES;
    isShowBackCover = self.manager.style.isShowBackCover;
    isShowPlaceHolderView = self.manager.style.isShowPlaceHolderView;
    isShowSlectedColor = YES;
    isScrollViewBounces = YES;
    
//    _enableIdxArr = @[];
}

+(instancetype)channelViewWithFrame:(CGRect)frame Manager:(WyhChannelManager *)manager{
    
    WyhChannelManagerView *channelView = [[WyhChannelManagerView alloc]initWithFrame:frame];
    
    NSAssert(manager, @"WyhChannelManager不得为空");
    
    channelView.manager = manager;
    
    [channelView initialize];
    
    [channelView createUI];
    
    return channelView;
}


-(void)createUI{
    
    [self initializeSubView];
    
    [self configUI];
}

-(void)initializeSubView{
    
    if (isShowBackCover) {
        [self addSubview:self.coverImageView];
        [self sendSubviewToBack:self.coverImageView];
    }
    
    [self addSubview:self.scrollView];
    
    [self.scrollView addSubview:self.topTipView];
    
    [self.scrollView addSubview:self.bottomTipView];
    
    //可在此自定义
    self.editBtn.frame = CGRectMake(self.topTipView.bounds.size.width -2*edgeX-2*self.manager.style.padding-15, topY/4, 30, topY/2);
    [self.topTipView addSubview:self.editBtn];
}

#pragma mark - config UI

-(void)configUI{
    
    [self configTopChannelView];
    
    [self configBottomTipView];
    
    [self configBottomChannelView];
    
}

-(void)configTopChannelView{
    
    NSUInteger idx = 0;
    
    for (WyhChannelModel *model in self.manager.topChannelArr) {
        
        WyhChannelView *view = [[WyhChannelView alloc]initWithFrame:CGRectMake(edgeX + idx%numberOfLine*(channelW+spaceX), topY + (idx/numberOfLine)*(channelH+spaceY), channelW, channelH)];
        view.model = model;
        view.isEdit = self.isEdit; /* setModel赋值需要在setIsEdit之前 */
        if (idx == self.manager.initialIndex && isShowSlectedColor && !self.isEdit) {
            self.manager.initialModel = model;
            self.initialView = view;
            view.contentLabel.textColor = self.manager.style.selectedTextColor;
        }else{
            view.contentLabel.textColor = self.manager.style.normalTextColor;
        }
        if(!model.isEnable){
            
            view.longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(toplongGesture:)];
//            view.panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(toppanGesture:)];
        }
        view.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toptapGesture:)];
        
        __weak typeof(&*self) weakSelf = self;
        [view closeHandleBlock:^(UIButton *sender) {
            [weakSelf performSelector:@selector(toptapGesture:) withObject:view.tapGes]; //点击x号
        }];
        [self.scrollView addSubview:view];
        [self.topViewArr addObject:view];
        
        idx++;
    }
}

-(void)configBottomChannelView{
    
//    WyhChannelView *toplastView = self.topViewArr[self.topViewArr.count - 1];
//    CGFloat bottomY = toplastView.frame.origin.y + toplastView.bounds.size.height;

    CGFloat bottomY = self.bottomTipView.frame.origin.y + self.bottomTipView.bounds.size.height;
    
    NSUInteger idx = 0;
    
    for (WyhChannelModel *model in self.manager.bottomChannelArr) {
        
        WyhChannelView *view = [[WyhChannelView alloc]initWithFrame:CGRectMake(edgeX + idx%numberOfLine*(channelW+spaceX), (idx/numberOfLine)*(channelH+spaceY) + bottomY, channelW, channelH)];
        view.model = model;
        view.isEdit = NO;
        view.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomtapGesture:)];
        [self.scrollView addSubview:view];
        [self.bottomViewArr addObject:view];
        
        idx++;
    }
    
    CGFloat totalHeight;
    if (self.bottomViewArr.count>0) {
        WyhChannelView *bottomlastView = self.bottomViewArr[self.bottomViewArr.count - 1];
        totalHeight = bottomlastView.frame.origin.y + bottomlastView.bounds.size.height;
    }else{
        totalHeight = self.bottomTipView.frame.origin.y + self.bottomTipView.frame.size.height;
    }
    
    if (isScrollViewBounces) {
        if (totalHeight <= self.bounds.size.height) {
            self.scrollView.contentSize = CGSizeMake(0, self.bounds.size.height + 20.0);
        }else{
            self.scrollView.contentSize = CGSizeMake(0, totalHeight + 20.0);
        }
    }else{
        self.scrollView.contentSize = CGSizeMake(0, totalHeight);
    }
    
}

-(void)configBottomTipView{
    WyhChannelView *toplastView = self.topViewArr[self.topViewArr.count - 1];
    CGFloat bottomY = toplastView.frame.origin.y + toplastView.bounds.size.height;
    self.bottomTipView.frame = CGRectMake(0, bottomY, self.bounds.size.width, topY);
}

#pragma mark - reconfig UI

-(void)reconfigTopViewsWithAnimation:(BOOL)animation{
    CGFloat duration = animation ? 0.3f : 0.f;
    
    [UIView animateWithDuration:duration animations:^{
        //其中包含占位的clearView
        [self.topViewArr enumerateObjectsUsingBlock:^(UIView *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WyhChannelView class]]) {
                WyhChannelView *channelView = (WyhChannelView *)obj;
                channelView.isTop = YES;
                channelView.isEdit = self.isEdit;
                channelView.frame = CGRectMake(edgeX + idx%numberOfLine*(channelW+spaceX), topY + (idx/numberOfLine)*(channelH+spaceY), channelW, channelH);
            }else{
                //占位图
                obj.frame = CGRectMake(edgeX + _currentIndex%numberOfLine*(channelW+spaceX)+self.manager.style.padding, topY + (_currentIndex/numberOfLine)*(channelH+spaceY)+self.manager.style.padding, channelW-2*self.manager.style.padding, channelH-2*self.manager.style.padding);
            }
        }];
    }];
    if (self.manager.initialModel.isTop && isShowSlectedColor &&!self.isEdit) {
        self.initialView.contentLabel.textColor = self.manager.style.selectedTextColor;
    }
}

-(void)reconfigBottomViewsWithAnimation:(BOOL)animation{
    
    
    CGFloat bottomY;
    if (self.topViewArr.count > 0) {
        WyhChannelView *toplastView = self.topViewArr[self.topViewArr.count - 1];
        bottomY = toplastView.frame.origin.y + toplastView.bounds.size.height;
    }else{
        bottomY = self.topTipView.frame.origin.y + self.topTipView.frame.size.height;
    }
    CGFloat duration = animation ? 0.3f : 0.f;
    [UIView animateWithDuration:duration animations:^{
        
        [self.bottomViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            WyhChannelView *channelView = obj;
            channelView.isTop = NO;
            channelView.isEdit = NO;
            channelView.contentLabel.textColor = self.manager.style.normalTextColor;
            channelView.frame = CGRectMake(edgeX + idx%numberOfLine*(channelW+spaceX), topY + (idx/numberOfLine)*(channelH+spaceY) + bottomY, channelW, channelH);
        }];
        
        self.bottomTipView.frame = CGRectMake(0, bottomY, self.bounds.size.width, topY);
    }];
    
    CGFloat totalHeight = 0.0;
    if (self.bottomViewArr.count > 0) {
        WyhChannelView *bottomlastView = self.bottomViewArr[self.bottomViewArr.count - 1];
        totalHeight = bottomlastView.frame.origin.y + bottomlastView.bounds.size.height;
    }else{
        totalHeight = self.bottomTipView.frame.origin.y + self.bottomTipView.bounds.size.height;
    }
    
    if (isScrollViewBounces) {
        if (totalHeight <= self.bounds.size.height) {
            self.scrollView.contentSize = CGSizeMake(0, self.bounds.size.height + 20.0);
        }else{
            self.scrollView.contentSize = CGSizeMake(0, totalHeight + 20.0);
        }
    }else{
        self.scrollView.contentSize = CGSizeMake(0, totalHeight);
    }
    
}

-(void)reconfigInitialIndex{
    
    NSUInteger currentIndex = [self.topViewArr indexOfObject:self.initialView];
    if (currentIndex != self.manager.initialIndex) {
        self.manager.initialIndex = currentIndex;
    }
}

#pragma mark - publish function

-(void)reloadChannels{
    
    [self.topViewArr removeAllObjects];
    [self.bottomViewArr removeAllObjects];
    
    [self.scrollView.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (![obj isEqual:self.topTipView]&&![obj isEqual:self.bottomTipView]){
            [obj removeFromSuperview];
        }
    }];
    
    [self configUI];
}

-(void)chooseChannelCallBack:(void (^)())callBack{
    
    _chooseChannelHandle = callBack;
}

#pragma mark - private function

-(void)setIsEdit:(BOOL)isEdit{
    
    _isEdit = isEdit;
    
    self.editBtn.selected = isEdit;
    
    if (isEdit) {
        
        [self.topViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[WyhChannelView class]]) {
                WyhChannelView *view = (WyhChannelView *)obj;
                view.contentLabel.textColor = self.manager.style.normalTextColor;
                view.isEdit = YES;
                //为了避免平移手势与scrollView滑动手势冲突
                WyhChannelModel *model = self.manager.topChannelArr[idx];
                if (!model.isEnable) {
                    view.panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(toppanGesture:)];
                }
            }
        }];

    }else{
        if (self.manager.initialModel.isTop && isShowSlectedColor) {
            self.initialView.contentLabel.textColor = self.manager.style.selectedTextColor;
        }
        [self.topViewArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            if ([obj isKindOfClass:[WyhChannelView class]]) {
                WyhChannelView *view = (WyhChannelView *)obj;
                view.isEdit = NO;
                
                //关闭编辑时取消滑动手势
                WyhChannelModel *model = self.manager.topChannelArr[idx];
                if (!model.isEnable) {
                    view.panGes = nil;
                }
            }
        }];
    }
}

-(void)setCloseBtn:(UIButton *)closeBtn{
    
    _closeBtn = closeBtn;
    
    [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
}

-(void)editAction:(UIButton *)sender{
    
    if (!sender.selected) {
        self.isEdit = YES;
    }else{
        self.isEdit = NO;
    }
    
//    sender.selected = !sender.selected;
}

-(void)closeAction:(id)sender{
    
    if (!self.manager.initialModel.isTop) {
        if (self.manager.callBack) {
            self.manager.callBack(self.manager.topChannelArr, self.manager.bottomChannelArr, self.manager.topChannelArr.count - 1); //若当前选中的频道被删除,则回调顶部最后一个
        }
    }else{
        if (self.manager.callBack) {
            self.manager.callBack(self.manager.topChannelArr, self.manager.bottomChannelArr, self.manager.initialIndex);
        }
    }
    
}

#pragma mark - top Pangesturerecognizer

-(void)toppanGesture:(UIPanGestureRecognizer *)panGes{
    
    if (!self.isEdit) {
        return;
    }
    
    WyhChannelView *touchView = (WyhChannelView *)panGes.view;
    [touchView.superview bringSubviewToFront:touchView];
    CGPoint movePoint;
    
    if (panGes.state == UIGestureRecognizerStateBegan) {
        
        if (isLongTapScale) {
            touchView.transformScale = 1.2f;
        }
        
        self.oldIndex = [self.topViewArr indexOfObject:touchView];
        
        self.oldModel = self.manager.topChannelArr[self.oldIndex];
        
        NSAssert(self.oldIndex < self.topViewArr.count, @"计算当前位置index超出范围");
        [self.topViewArr removeObjectAtIndex:self.oldIndex];
        
    }
    else if(panGes.state == UIGestureRecognizerStateChanged){
        
        movePoint = [panGes locationInView:self.scrollView];
        
        touchView.center = CGPointMake(movePoint.x, movePoint.y);
        
        //        NSLog(@"change:%@",NSStringFromCGPoint(touchView.center));
        
        CGFloat centerY = touchView.center.y;
        CGFloat centerX = touchView.center.x;
        
        NSUInteger listNum = (int)((centerX - edgeX)/(channelW+0.5*spaceX));//当前列
        NSUInteger lineNum = (int)((centerY - topY)/(channelH+0.5*spaceY));//当前行
        _currentIndex = (listNum)+(lineNum)*numberOfLine;
        
        if (_currentIndex > self.topViewArr.count - 1) {
            _currentIndex = _oldIndex; //此时超出计算范围
        }else{
            WyhChannelModel *currentModel = self.manager.topChannelArr[_currentIndex];
            if (currentModel.isEnable) {
                _currentIndex = _oldIndex;
            }
        }
        //        NSAssert(_currentIndex < self.topViewArr.count, @"计算当前位置index超出范围");
        if (_currentIndex < self.topViewArr.count) {
            
            if ([self.topViewArr containsObject:self.placeHolderView]) {
                [self.topViewArr removeObject:self.placeHolderView];
            }
            
            if (!self.placeHolderView.superview) {
                
                [self.scrollView addSubview:self.placeHolderView];
                [self.scrollView sendSubviewToBack:self.placeHolderView];
            }
            [self.topViewArr insertObject:self.placeHolderView atIndex:_currentIndex];
            
            self.placeHolderView.frame = CGRectMake(edgeX + _currentIndex%numberOfLine*(channelW+spaceX)+self.manager.style.padding, topY + (_currentIndex/numberOfLine)*(channelH+spaceY)+self.manager.style.padding, channelW-2*self.manager.style.padding, channelH-2*self.manager.style.padding);
            
            [self reconfigTopViewsWithAnimation:YES];
            
        }
        
    }
    else if (panGes.state == UIGestureRecognizerStateEnded) {
        
        touchView.transformScale = 1.0f;
        
        if ([self.topViewArr containsObject:self.placeHolderView]) {
            [self.topViewArr removeObject:self.placeHolderView];
        }
        [self.topViewArr insertObject:touchView atIndex:_currentIndex];
        if (self.placeHolderView.superview) {
            [self.placeHolderView removeFromSuperview];
        }
        [self.manager.topChannelArr removeObject:self.oldModel];
        [self.manager.topChannelArr insertObject:self.oldModel atIndex:_currentIndex];
        //        if ([self.manager.topChannelArr containsObject:self.placeHolderModel]) {
        //        [self.manager.topChannelArr insertObject:oldModel atIndex:_currentIndex];
        //        }
        
        [self reconfigTopViewsWithAnimation:YES];
        [self reconfigInitialIndex];
    }
    
}

#pragma mark - top Longpressgesturerecognizer

-(void)toplongGesture:(UILongPressGestureRecognizer *)longGes{
    
    WyhChannelView *touchView = (WyhChannelView *)longGes.view;
    [touchView.superview bringSubviewToFront:touchView];
    CGPoint movePoint;
    
    if (longGes.state == UIGestureRecognizerStateBegan) {
        
        self.isEdit = YES;
        
        if (isLongTapScale) {
            touchView.transformScale = 1.2f;
        }
        
        self.oldIndex = [self.topViewArr indexOfObject:touchView];
        
        self.oldModel = self.manager.topChannelArr[self.oldIndex];
        
        NSAssert(self.oldIndex < self.topViewArr.count, @"计算当前位置index超出范围");
        [self.topViewArr removeObjectAtIndex:self.oldIndex];
        
        self.currentIndex = self.oldIndex;
        
    }
    else if(longGes.state == UIGestureRecognizerStateChanged){
        
        movePoint = [longGes locationInView:self.scrollView];
        
        touchView.center = CGPointMake(movePoint.x, movePoint.y);
        
//        NSLog(@"change:%@",NSStringFromCGPoint(touchView.center));
        
        CGFloat centerY = touchView.center.y;
        CGFloat centerX = touchView.center.x;
        
        NSUInteger listNum = (int)((centerX - edgeX)/(channelW+0.5*spaceX));//当前列
        NSUInteger lineNum = (int)((centerY - topY)/(channelH+0.5*spaceY));//当前行
        _currentIndex = (listNum)+(lineNum)*numberOfLine;
        
        if (_currentIndex > self.topViewArr.count - 1) {
            _currentIndex = _oldIndex; //此时超出计算范围
        }else{
            WyhChannelModel *currentModel = self.manager.topChannelArr[_currentIndex];
            if (currentModel.isEnable) {
                _currentIndex = _oldIndex;
            }
        }
//        NSAssert(_currentIndex < self.topViewArr.count, @"计算当前位置index超出范围");
        if (_currentIndex < self.topViewArr.count) {
            
            if ([self.topViewArr containsObject:self.placeHolderView]) {
                [self.topViewArr removeObject:self.placeHolderView];
            }
            if (!self.placeHolderView.superview) {
                
                [self.scrollView addSubview:self.placeHolderView];
                [self.scrollView sendSubviewToBack:self.placeHolderView];
            }
            [self.topViewArr insertObject:self.placeHolderView atIndex:_currentIndex];
            
            self.placeHolderView.frame = CGRectMake(edgeX + _currentIndex%numberOfLine*(channelW+spaceX)+self.manager.style.padding, topY + (_currentIndex/numberOfLine)*(channelH+spaceY)+self.manager.style.padding, channelW-2*self.manager.style.padding, channelH-2*self.manager.style.padding);
            [self reconfigTopViewsWithAnimation:YES];
            
        }
        
    }
    else if (longGes.state == UIGestureRecognizerStateEnded) {
        
        touchView.transformScale = 1.0f;
        
        if ([self.topViewArr containsObject:self.placeHolderView]) {
            [self.topViewArr removeObject:self.placeHolderView];
        }
        [self.topViewArr insertObject:touchView atIndex:_currentIndex];
        if (self.placeHolderView.superview) {
            [self.placeHolderView removeFromSuperview];
        }
        [self.manager.topChannelArr removeObject:self.oldModel];
        [self.manager.topChannelArr insertObject:self.oldModel atIndex:_currentIndex];

//        for (WyhChannelModel *model in self.manager.topChannelArr) {
//            NSLog(@"name：%@",model.channel_name);
//        }
        [self reconfigTopViewsWithAnimation:YES];
        [self reconfigInitialIndex];
    }
}
#pragma mark - top tapGesturerecognizer

-(void)toptapGesture:(UITapGestureRecognizer *)tapGes{
    
    WyhChannelView *topView = (WyhChannelView *)tapGes.view;
    NSUInteger currentIndex = [self.topViewArr indexOfObject:topView];
    
    if (!self.isEdit) {
        
        self.manager.initialIndex = currentIndex;
        
        [WyhChannelManager setUpdateIfNeeds];
        
        if (self.chooseChannelHandle) {
            self.chooseChannelHandle();
        }
        
    }else{
        
        WyhChannelModel *currentModel = self.manager.topChannelArr[currentIndex];
        if (currentModel.isEnable) {
            return;
        }
        currentModel.isTop = NO;
        if([topView isEqual:self.initialView]) {
            self.manager.initialIndex = -1;/** tip: 若点击的是当前频道，则当前index置负 */
        }
        if (currentIndex < self.topViewArr.count) {
            
            topView.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(bottomtapGesture:)];
            topView.longGes = nil;
            topView.panGes = nil;
            [self.topViewArr removeObjectAtIndex:currentIndex];
            [self.bottomViewArr insertObject:topView atIndex:0];
            [self.manager.topChannelArr removeObjectAtIndex:currentIndex];
            [self.manager.bottomChannelArr insertObject:currentModel atIndex:0];
        }
        [self reconfigTopViewsWithAnimation:YES];
        [self reconfigBottomViewsWithAnimation:YES];
    }
}

#pragma mark - bottom tapGesturerecognizer

-(void)bottomtapGesture:(UITapGestureRecognizer *)tapGes{
    
    WyhChannelView *bottomView = (WyhChannelView *)tapGes.view;
    NSUInteger currentIndex = [self.bottomViewArr indexOfObject:bottomView];
    WyhChannelModel *currentModel = self.manager.bottomChannelArr[currentIndex];
    currentModel.isTop = YES;

    if (currentIndex < self.bottomViewArr.count) {
        
        bottomView.tapGes = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(toptapGesture:)];
        bottomView.longGes = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(toplongGesture:)];
        bottomView.panGes = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(toppanGesture:)];
        [self.bottomViewArr removeObjectAtIndex:currentIndex];
        [self.topViewArr addObject:bottomView];
        [self.manager.bottomChannelArr removeObjectAtIndex:currentIndex];
        [self.manager.topChannelArr addObject:currentModel];
    }
    [self reconfigTopViewsWithAnimation:YES];
    [self reconfigBottomViewsWithAnimation:YES];
    
}



#pragma mark - lazy

-(UIView *)topTipView{
    
    if (!_topTipView) {
        UILabel *label = [[UILabel alloc]init];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"我的频道";
        label.font = [UIFont systemFontOfSize:15.0];
        _topTipView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, topY)];
        _topTipView.backgroundColor = [UIColor clearColor];
        label.frame = CGRectMake(edgeX+self.manager.style.padding, 0, _topTipView.bounds.size.width-edgeX-self.manager.style.padding, _topTipView.bounds.size.height);
        [_topTipView addSubview:label];
    }
    return _topTipView;
}

-(UIView *)bottomTipView{
    if (!_bottomTipView) {
        _bottomTipView = [[UIView alloc]initWithFrame:CGRectZero];
        _bottomTipView.backgroundColor = [UIColor clearColor];
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
        label.backgroundColor = [UIColor clearColor];
        label.text = @"推荐频道";
        label.font = [UIFont systemFontOfSize:15.0];
        label.frame = CGRectMake(edgeX+self.manager.style.padding, 0, _topTipView.bounds.size.width-edgeX-self.manager.style.padding, topY);
        [_bottomTipView addSubview:label];
    }
    return _bottomTipView;
}

-(NSMutableArray *)topViewArr{
    if (!_topViewArr) {
        _topViewArr = [NSMutableArray new];
    }
    return _topViewArr;
}

-(NSMutableArray *)bottomViewArr{
    if (!_bottomViewArr) {
        _bottomViewArr = [NSMutableArray new];
    }
    return _bottomViewArr;
}

-(UIScrollView *)scrollView{
    
    if (!_scrollView) {
        
        _scrollView = [[UIScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, viewWidth, viewHeight);
        _scrollView.bounces = isScrollViewBounces;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(viewWidth, viewHeight);
        if (isShowBackCover) {
            _scrollView.backgroundColor = [UIColor clearColor];
        }else{
            _scrollView.backgroundColor = scrollViewBackgroundColor;
        }
        
    }
    return _scrollView;
}

-(UIButton *)editBtn{
    
    if (!_editBtn) {
        _editBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_editBtn setTitle:@"编辑" forState:(UIControlStateNormal)];
        [_editBtn setTitle:@"完成" forState:(UIControlStateSelected)];
        _editBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
        [_editBtn setTitleColor:[UIColor blueColor] forState:(UIControlStateNormal)];
        [_editBtn addTarget:self action:@selector(editAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _editBtn;
}

-(UIImageView *)placeHolderView{

    if (!_placeHolderView) {
        _placeHolderView = [[UIImageView alloc]initWithImage:placeHolderImage];
//        _placeHolderView.backgroundColor = [UIColor greenColor]; //test
    }
    if (!isShowPlaceHolderView) {
        _placeHolderView.hidden = YES;
    }else {
        _placeHolderView.hidden = NO;
    }
    
    return _placeHolderView;
}

-(UIImageView *)coverImageView{
    if (coverImage) {
        if (!_coverImageView) {
            _coverImageView = [[UIImageView alloc]initWithImage:coverImage];
            _coverImageView.frame = self.bounds;
        }
    }
    return _coverImageView;
}

//-(NSArray<NSNumber *> *)enableIdxArr{
//    
//    if (!_enableIdxArr) {
//        _enableIdxArr = [NSMutableArray new];
//    }
//    return _enableIdxArr;
//}

@end
