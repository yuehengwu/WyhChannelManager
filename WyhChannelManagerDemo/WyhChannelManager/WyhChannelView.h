//
//  WyhChannelView.h
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/22.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WyhChannelModel;
@class WyhChannelManager;


typedef void(^closeHandleBlock)(UIButton *sender);

@interface WyhChannelView : UIView

@property (nonatomic, strong) WyhChannelModel *model;

@property (nonatomic, strong) WyhChannelManager *manager;

/** 是否是编辑模式 */
@property (nonatomic, assign, setter=setEditStyle:) BOOL isEdit;
/** 当前是否为火热 */
@property (nonatomic, assign, setter=setHotStyle:) BOOL isHot;
/** 设置当前频道顶部与底部样式 */
@property (nonatomic, assign, setter=setCurrentStyleWith:) BOOL isTop;
/** 关闭的按钮 */
@property (nonatomic, strong) UIButton *closeBtn;
/** 标题label */
@property (nonatomic, strong) UILabel *contentLabel;
/** 当前缩放的比例 */
@property (nonatomic, assign) CGFloat transformScale;
/** 平移手势 */
@property (nonatomic, strong) UIPanGestureRecognizer *panGes;
/** 点击手势 */
@property (nonatomic, strong) UITapGestureRecognizer *tapGes;
/** 长按手势 */
@property (nonatomic, strong) UILongPressGestureRecognizer *longGes;
/** 当前label的size */
@property (nonatomic, assign) CGSize labelSize;
/** s */
@property (nonatomic, strong, readonly) UIImageView *coverImageView;

@property (nonatomic, strong, readonly) UIImageView *hotImageView;



/**
 点击x号的回调
 
 @param closeBlock 回调block
 */
-(void)closeHandleBlock:(closeHandleBlock)closeBlock;

@end
