//
//  WyhContentView.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/15.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "WyhScrollPageDelegate.h"
#import "WyhCollectionView.h"
#import "WyhConst.h"
#import "WyhSegmentView.h"

@interface WyhContentView : UIView

@property (nonatomic, strong ,readonly) WyhCollectionView *collectionView;

@property (nonatomic, assign, readonly) NSUInteger currentIndex;

-(instancetype)initWithFrame:(CGRect)frame
                 SegmentView:(WyhSegmentView *)segment
        ParentViewController:(UIViewController *)parentVC
                    Delegate:(id<WyhScrollPageDelegate>) delegate;

/**
 外界设置位置偏移

 @param offset   偏移量
 @param animated 是否开启动画
 */
-(void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;

@end
