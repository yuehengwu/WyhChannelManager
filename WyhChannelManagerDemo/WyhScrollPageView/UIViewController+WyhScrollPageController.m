//
//  UIViewController+WyhScrollPageController.m
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/16.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "UIViewController+WyhScrollPageController.h"
#import <objc/runtime.h>
#import "WyhScrollPageDelegate.h"

static char const wyhKey = '/';

@implementation UIViewController (WyhScrollPageController)

- (UIViewController *)wyh_scrollViewController {
    UIViewController *controller = self;
    if (![controller conformsToProtocol:@protocol(WyhScrollPageDelegate)]) {
        controller = controller.parentViewController;
    }
    return controller;
}
-(void)setWyh_currentIndex:(NSInteger)wyh_currentIndex{
    
    objc_setAssociatedObject(self, &wyhKey, @(wyh_currentIndex), OBJC_ASSOCIATION_ASSIGN);
    
}
-(NSInteger)wyh_currentIndex{
    return [objc_getAssociatedObject(self, &wyhKey) integerValue];
}

@end
