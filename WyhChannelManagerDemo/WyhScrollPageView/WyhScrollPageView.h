//
//  WyhScrollPageView.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/18.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WyhSegmentStyle.h"
#import "WyhScrollPageDelegate.h"
#import "WyhSegmentView.h"
#import "WyhContentView.h"
#import "UIView+WyhExtension.h"
#import "UIViewController+WyhScrollPageController.h"
#import "WyhConst.h"

@interface WyhScrollPageView : UIView

-(instancetype)initWithFrame:(CGRect)frame
                       style:(WyhSegmentStyle *)style
                  titleArray:(NSArray *)titles
        parentViewController:(UIViewController *)parentVC
                    delegate:(id<WyhScrollPageDelegate>)delegate;


-(void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated;

@end
