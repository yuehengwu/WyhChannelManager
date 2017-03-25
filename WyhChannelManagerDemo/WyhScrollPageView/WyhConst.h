//
//  WyhConst.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/15.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface WyhConst : NSObject

//当前版本
#define WYH_iOSVersion ((float)[[[UIDevice currentDevice] systemVersion] doubleValue])

//16进制颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

//屏幕尺寸
#define ScreenWidth [UIScreen mainScreen].bounds.size.width

#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//异步线程
#define WYH_GlobalQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)

//主线程
#define WYH_MainQueue dispatch_get_main_queue()

UIKIT_EXTERN NSString *const cellReuserIndentifier;

@end
