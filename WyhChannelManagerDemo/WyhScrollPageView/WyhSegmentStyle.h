//
//  WyhSegmentStyle.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/17.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WyhSegmentStyle : NSObject

@property (nonatomic, strong) UIFont *font;

/**
 标题是否可以滚动
 */
@property (nonatomic, assign) BOOL isScrollTitle;

/**
 标题栏是否可以滚动
 */
@property (nonatomic, assign) BOOL isBounces;

/**
 遮盖的颜色(暂无)
 */
@property (nonatomic, strong) UIColor *coverBackgroudColor;

/**
 当宽title的宽度 <= 顶部WyhSegmentView宽度时将平分标题
 */
@property (nonatomic, assign) BOOL isAutoAdjustTitlesWidth;

/**
 标题之间的间隙 默认为15.0
 */
@property (assign, nonatomic) CGFloat titleMargin;

/**
 此属性只针对于WyhScrollPageView生效 默认40
 */
@property (nonatomic, assign) CGFloat segmentHeight;

/**
 默认时的标题颜色
 */
@property (nonatomic, strong) UIColor *normalTitleColor;

/**
 选中时的标题颜色
 */
@property (nonatomic, strong) UIColor *selectTitleColor;

/**
 滚动条颜色
 */
@property (nonatomic, strong) UIColor *scrollBarColor;

/**
 是否展示底部滚动条
 */
@property (nonatomic, assign) BOOL isShowScrollBar;

/**
 若想固定滚动条宽度，则设置此属性 默认0
 */
@property (nonatomic, assign) CGFloat scrollBarWidth;

/**
 滚动条高度 默认3
 */
@property (nonatomic, assign) CGFloat scrollBarHeight;

/**
 当前标题最大缩放倍数 默认1.3
 */
@property (nonatomic, assign) CGFloat titleMaxScale;

/**
 是否缩放标题
 */
@property (nonatomic, assign) BOOL isScaleTitle;

/**
 当拖拽时,滚动条是否需要即时移动
 */
@property (nonatomic, assign) BOOL isBarMoveWhenScrolled;

@end
