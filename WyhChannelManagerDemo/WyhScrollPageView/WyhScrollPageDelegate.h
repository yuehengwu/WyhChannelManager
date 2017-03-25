//
//  WyhScrollPageDelegate.h
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/15.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@protocol WyhScrollPageChirldVcDelegate <NSObject>



@end

@protocol WyhScrollPageDelegate <NSObject>

-(NSUInteger )wyh_numberOfChilrdVCs;

-(UIViewController<WyhScrollPageChirldVcDelegate> *)wyh_childViewController:(UIViewController<WyhScrollPageChirldVcDelegate> *)reuseChildVC ForIndex:(NSUInteger)index;




@end
