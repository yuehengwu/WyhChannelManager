//
//  WyhTitleView.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/17.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WyhSegmentStyle.h"
@interface WyhTitleView : UIView

/**
 标题
 */
@property (nonatomic, strong) NSString *text;

/**
 是否显示图片(暂未开通)
 */
@property (nonatomic, assign) BOOL isShowImage;

/**
 当前标题视图的总高
 */
@property (nonatomic, assign) CGFloat viewHeight;

/**
 获取当前文字的尺寸
 */
@property (nonatomic, assign, readonly) CGSize labelSize;

/**
 当前的label
 */
@property (nonatomic, strong ,readonly) UILabel *label;

//@property (nonatomic, strong) UIView *scrollBar;

/**
 文字颜色
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 当前滚动条的位置
 */
@property (nonatomic, assign) CGRect scrollBarFrame;

/**
 当前缩放的倍数
 */
@property (assign, nonatomic) CGFloat currentTransformX;

/**
 字体设置应在设置text方法之前
 */
@property (nonatomic, strong) UIFont *font;

/**
 调整整体布局,需要设置完frame之后进行设置
 */
-(void)adjustSubViewsWithStyle:(WyhSegmentStyle *)style;

@end
