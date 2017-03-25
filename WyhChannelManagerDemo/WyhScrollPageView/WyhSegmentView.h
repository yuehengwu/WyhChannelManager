//
//  WyhSegmentView.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/15.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WyhTitleView.h"
#import "WyhSegmentStyle.h"
#import "WyhScrollPageDelegate.h"

typedef void(^TapHandleBlock)(WyhTitleView *wyhTitleLabel,NSUInteger index);



@interface WyhSegmentView : UIView

@property (nonatomic, strong) WyhSegmentStyle *wyhStyle;

@property (nonatomic, copy ,readonly) TapHandleBlock tapblock;

@property (nonatomic, strong) UIView *scrollBar;


-(instancetype)initWithFrame:(CGRect)frame
                       style:(WyhSegmentStyle *)style
                  titleArray:(NSArray *)titles
        parentViewController:(UIViewController *)parentVC
                    delegate:(id<WyhScrollPageDelegate>)delegate
              tapHandleBlock:(TapHandleBlock)tapBlock;


/**
 *  切换下标时更新UI
 */
-(void)adjustUIWhenDidEndDragToCurrentIndex:(NSUInteger)currentIndex;

/**
 *  根据进度更新UI
 */
-(void)adjustUIWithProgress:(CGFloat)progress OldIndex:(NSInteger)oldIndex CurrentIndex:(NSInteger)currentIndex;

/**
 *  设置选中的下标
 */
- (void)setSelectedIndex:(NSInteger)index animated:(BOOL)animated;

/**
 ! 根据标题重置更新
 
 @param titles 新标题数组
 */
- (void)reloadTitlesWithNewTitles:(NSArray *)titles;

@end
