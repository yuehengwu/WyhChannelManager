//
//  UIViewController+WyhScrollPageController.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/16.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (WyhScrollPageController)


/**
 所有子控制的父控制器, 方便在每个子控制页面直接获取到父控制器进行其他操作
 */
@property (nonatomic, weak, readonly) UIViewController *wyh_scrollViewController;

/**
 当前控制器的索引值
 */
@property (nonatomic, assign) NSInteger wyh_currentIndex;

@end
