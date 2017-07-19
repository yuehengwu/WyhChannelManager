//
//  WyhChannelManager.m
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/22.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhChannelManager.h"


@implementation WyhChannelStyle

-(instancetype)init{
    
    self = [super init];
    if (self) {
#pragma mark - WyhChannelView style
        
        self.closeBtnW = 15.f;
        self.padding = self.closeBtnW/2.f;
        self.font = [UIFont systemFontOfSize:12.f];
        self.normalTextColor = [UIColor blackColor];
        self.selectedTextColor = [UIColor redColor];
        self.closeImage = [UIImage imageNamed:@"plus_icon_pressed"];
        self.hotImage = [UIImage imageNamed:@"hot"];
        self.coverTopImage = [UIImage imageNamed:@""];
        self.coverBottomImage = [UIImage imageNamed:@""];
        self.hotImageW = 20.f;
        self.isShowBorder = YES;
        self.isShowCover = NO;
        self.isShowHot = YES;
        
#pragma mark - WyhChannelManagerView style
        
        self.isShowBackCover = NO;
        self.isShowPlaceHolderView = NO;
    }
    return self;
}

@end



@implementation WyhChannelManager

static WyhChannelManager *manager = nil;

+(instancetype)defaultManager{
    
    if (!manager) {
        manager = [[WyhChannelManager alloc]init];
    }
    return manager;
    
}

+(instancetype)allocWithZone:(struct _NSZone *)zone{
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [super allocWithZone:zone];
    });
    return manager;
}

+(void)updateChannelCallBack:(updateCallBack)callback{
    
    manager = [WyhChannelManager defaultManager];
    
    manager.callBack = callback;
    
}

+(instancetype)updateWithTopArr:(NSArray<WyhChannelModel *> *)top BottomArr:(NSArray<WyhChannelModel *> *)bottom InitialIndex:(NSUInteger)initialIndex newStyle:(WyhChannelStyle *)style{
    
    NSAssert(initialIndex < top.count, @"选中的initialIndex超过了顶部数组个数");
    
    manager = [WyhChannelManager defaultManager];
    manager.topChannelArr = nil;
    manager.bottomChannelArr = nil;
    manager.topChannelArr = [NSMutableArray arrayWithArray:top];
    manager.bottomChannelArr = [NSMutableArray arrayWithArray:bottom];
    manager.initialIndex = initialIndex;
    manager.style = style==nil ? [WyhChannelStyle new] : style;
    
    return manager;
}

+(void)setUpdateIfNeeds{
    
    if (!manager.initialModel.isTop && manager.initialIndex<0) {
        if (manager.callBack) {
            manager.callBack(manager.topChannelArr, manager.bottomChannelArr, manager.topChannelArr.count - 1); //若当前选中的频道被删除,则回调顶部最后一个
        }
    }else{
        if (manager.callBack) {
            manager.callBack(manager.topChannelArr, manager.bottomChannelArr, manager.initialIndex);
        }
    }
}

@end
