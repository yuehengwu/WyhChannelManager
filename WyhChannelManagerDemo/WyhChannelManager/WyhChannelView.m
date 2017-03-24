//
//  WyhChannelView.m
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/22.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhChannelView.h"
#import "WyhChannelModel.h"
#import "WyhChannelManager.h"

static CGFloat  padding;
static CGFloat  closeBtnW;
static CGFloat  hotImageW;
static UIFont   *font;
static UIColor  *normalTextColor;
static UIColor  *selectedTextColor;
static UIImage  *closeImage;
static UIImage  *hotImage;
static UIImage  *coverTopImage;
static UIImage  *coverBottomImage;
static BOOL     isShowCover;
static BOOL     isShowHot;
static BOOL     isShowBorder;

@interface WyhChannelView()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIImageView *hotImageView;

@property (nonatomic, copy) closeHandleBlock closeBlock;

@end

@implementation WyhChannelView

-(void)initialize{
    /**
     *  目前样式全部从WyhChannelStyle中取
     *  具体属性含义请前往WyhChannelManager.h中查看
     */
    WyhChannelManager *manager = [WyhChannelManager defaultManager];
    closeBtnW = manager.style.closeBtnW;
    padding = manager.style.padding;
    font = manager.style.font;
    normalTextColor = manager.style.normalTextColor;
    selectedTextColor = manager.style.selectedTextColor;
    closeImage = manager.style.closeImage;
    hotImage = manager.style.hotImage;
    hotImageW = manager.style.hotImageW;
    coverTopImage = manager.style.coverTopImage;
    coverBottomImage = manager.style.coverBottomImage;
    isShowCover = manager.style.isShowCover;
    isShowHot = manager.style.isShowHot;
    isShowBorder = manager.style.isShowBorder;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        [self initialize];
        [self createUI];
    }
    return self;
}

-(void)createUI{
    
    self.userInteractionEnabled = YES;
    
    
    self.contentLabel.layer.masksToBounds = YES;
    self.contentLabel.frame = CGRectMake(padding, padding, self.bounds.size.width-2*padding, self.bounds.size.height-2*padding);
    
    if (isShowBorder) {
        self.contentLabel.layer.borderColor = [UIColor grayColor].CGColor;
        self.contentLabel.layer.borderWidth = 0.5f;
        self.contentLabel.layer.cornerRadius = 5.f;
    }
    
    [self addSubview:self.contentLabel];
    
    if (isShowCover) {
        
        self.coverImageView.frame = CGRectMake(padding, padding, self.bounds.size.width-2*padding, self.bounds.size.height-2*padding);
        [self addSubview:self.coverImageView];
        [self sendSubviewToBack:self.coverImageView];
    }
    
    if (isShowHot) {
        self.hotImageView.frame = CGRectMake(self.bounds.size.width - hotImageW, 0, hotImageW, hotImageW);
        [self addSubview:self.hotImageView];
        [self insertSubview:self.hotImageView aboveSubview:self.contentLabel];
        self.hotImageView.hidden = YES;
    }
    
    if (closeImage) {
        self.closeBtn.frame = CGRectMake(self.bounds.size.width - closeBtnW, 0, closeBtnW, closeBtnW);
        [self addSubview:self.closeBtn];
        [self insertSubview:self.closeBtn aboveSubview:self.contentLabel];
        self.closeBtn.hidden = YES;
    }
    
}

#pragma mark - publish function

-(void)closeHandleBlock:(closeHandleBlock)closeBlock{
    
    _closeBlock = closeBlock;
    
}


#pragma mark - setter

-(void)setCurrentStyleWith:(BOOL)isTop{
    
    _isTop = isTop;
    
    if (isTop==NO) {
        self.closeBtn.hidden = YES;
        if (isShowCover && coverBottomImage) {
            self.coverImageView.image = coverBottomImage;
        }
    }else{
        if (isShowCover && coverTopImage) {
            self.coverImageView.image = coverTopImage;
        }
        if (_isEdit && !_model.isEnable) {
            self.closeBtn.hidden = NO;
        }
    }
}

-(void)setEditStyle:(BOOL)isEdit{
    
    _isEdit = isEdit;
    
    //若不可编辑,则不设置任何编辑样式
    if (_model.isEnable) {
        return;
    }
    
    if (isEdit) {
        self.closeBtn.hidden = NO;
        if (_model.isHot) {
            self.hotImageView.hidden = YES;
        }
    }else {
        self.closeBtn.hidden = YES;
        if (_model.isHot) {
            self.hotImageView.hidden = NO;
        }
    }
    
}

-(void)setHotStyle:(BOOL)isHot{
    
    NSAssert(hotImage, @"设置的火热图标不能为空");
    
    _isHot = isHot;
    if (isShowHot) {
        self.hotImageView.hidden = !isHot;
    }
    
}

-(void)setTransformScale:(CGFloat)transformScale{
    
    _transformScale = transformScale;
    
    self.transform = CGAffineTransformMakeScale(transformScale, transformScale);
    
}

-(void)setModel:(WyhChannelModel *)model{
    
    if (_model != model) {
        _model = model;
        self.isTop = model.isTop;
        self.isHot = model.isHot;
        self.contentLabel.text = model.channel_name;
    }
    
}

-(void)setLongGes:(UILongPressGestureRecognizer *)longGes{
    
    if (longGes) {
        [self removeGestureRecognizer:_longGes];
        _longGes = longGes;
        [self addGestureRecognizer:longGes];
    }else{
        [self removeGestureRecognizer:_longGes];
    }
    
}

-(void)setPanGes:(UIPanGestureRecognizer *)panGes{
    
    if (panGes) {
        [self removeGestureRecognizer:_panGes];
        _panGes = panGes;
        [self addGestureRecognizer:panGes];
    }else{
        [self removeGestureRecognizer:_panGes];
    }
}

-(void)setTapGes:(UITapGestureRecognizer *)tapGes{
    
    if (tapGes) {
        [self removeGestureRecognizer:_tapGes];
        _tapGes = tapGes;
        [self addGestureRecognizer:tapGes];
        
    }else{
        [self removeGestureRecognizer:_tapGes];
    }
}

#pragma mark - getter

-(CGSize)labelSize{
    
    return self.contentLabel.bounds.size;
}

-(UILabel *)contentLabel{
    
    if (!_contentLabel) {
        _contentLabel = [[UILabel alloc]init];
        _contentLabel.numberOfLines = 1;
        _contentLabel.textAlignment = NSTextAlignmentCenter;
        _contentLabel.font = font;
        _contentLabel.textColor = normalTextColor;
    }
    return _contentLabel;
}

-(UIImageView *)coverImageView{
    
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    }
    return _coverImageView;
}

-(UIImageView *)hotImageView{
    
    if (!_hotImageView) {
        _hotImageView = [[UIImageView alloc]initWithImage:hotImage];
    }
    return _hotImageView;
}

-(UIButton *)closeBtn{
    
    if (!_closeBtn) {
        _closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_closeBtn setImage:closeImage forState:(UIControlStateNormal)];
        [_closeBtn addTarget:self action:@selector(closeAction:) forControlEvents:(UIControlEventTouchUpInside)];
    }
    return _closeBtn;
}

#pragma mark - close Action

-(void)closeAction:(UIButton *)sender{
    if (self.closeBlock) {
        self.closeBlock(sender);
    }
}

@end
