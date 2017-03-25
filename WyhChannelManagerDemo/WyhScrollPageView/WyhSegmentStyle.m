//
//  WyhSegmentStyle.m
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/17.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhSegmentStyle.h"

@implementation WyhSegmentStyle


-(instancetype)init{
    
    if (self = [super init]) {
        
        //初始化所有样式的默认值
        self.font = [UIFont systemFontOfSize:14];
        self.normalTitleColor = [UIColor blackColor];
        self.selectTitleColor = [UIColor redColor];
        self.titleMargin = 15.0;
        self.isBounces = YES;
        self.isScrollTitle = YES;
        self.coverBackgroudColor = [UIColor whiteColor];
        self.isScrollTitle = YES;
        self.isShowScrollBar = YES;
        self.isAutoAdjustTitlesWidth = YES;
        self.scrollBarColor = [UIColor orangeColor];
        self.scrollBarHeight = 3;
        self.scrollBarWidth = 0;
        self.segmentHeight = 50;
        self.titleMaxScale = 1.3f;
        self.isScaleTitle = YES;
        self.isBarMoveWhenScrolled = YES;
    }
    return self;
}

@end
