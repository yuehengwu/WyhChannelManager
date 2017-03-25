//
//  WyhChannelModel.h
//  WyhChannelManagerDemo
//
//  Created by wyh on 2017/3/22.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
 *  整体频道模型
 *  如果你觉得模型中的属性不够用或与产品需求不符,请尝试自己添加
 *  若遇到问题请尝试联系我
 *  QQ:  609223770@qq.com
 *  简书: http://www.jianshu.com/u/b76e3853ae0b
 */
@interface WyhChannelModel : NSObject

/** 当前频道名称 */
@property (nonatomic, strong) NSString *channel_name;
/** 当前频道id,此属性一般实战项目中会用到 */
@property (nonatomic, strong) NSString* channel_id;
/** 当前频道是否是顶部 */
@property (nonatomic, assign) BOOL isTop;
/** 当前频道是否为热门 */
@property (nonatomic, assign) BOOL isHot;

/** @! 当前频道是否不可编辑
 *  @! 此属性只针对isTop==YES时生效
 *  @! 注意此属性建议针对不可编辑频道不固定或从后台请求数据时设置
 *  @! 若设置此属性,则不需要在WyhChannelManagerView中再设置enableIdxArr */
@property (nonatomic, assign) BOOL isEnable;

@end
