//
//  UIView+WyhExtension.m
//  WyhShowEmptyCategory
//
//  Created by 吴岳恒 on 2017/2/8.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "UIView+WyhExtension.h"

@implementation UIView (WyhExtension)

-(void)setWyh_x:(CGFloat)wyh_x{
    
    CGRect frame = self.frame;
    frame.origin.x = wyh_x;
    self.frame = frame;
    
}

-(CGFloat)wyh_x{
    
    return self.frame.origin.x;
    
}

-(void)setWyh_y:(CGFloat)wyh_y{
    
    CGRect frame = self.frame;
    frame.origin.y = wyh_y;
    self.frame = frame;
    
}

-(CGFloat)wyh_y{
    
    return self.frame.origin.y;
    
}

-(void)setWyh_w:(CGFloat)wyh_w{
    
    CGRect frame = self.frame;
    frame.size.width = wyh_w;
    self.frame = frame;
    
}

-(CGFloat)wyh_w{
    
    return self.frame.size.width;
    
}

-(void)setWyh_h:(CGFloat)wyh_h{
    
    CGRect frame = self.frame;
    frame.size.height = wyh_h;
    self.frame = frame;
    
}

-(CGFloat)wyh_h{
    
    return self.frame.size.height;
    
}

-(CGFloat)wyh_top{
    
    return self.frame.origin.y;
    
}

-(CGFloat)wyh_bottom{
    
    return self.frame.origin.y + self.frame.size.height;
}

-(CGFloat)wyh_left{
    
    return self.frame.origin.x;
    
}

-(CGFloat)wyh_right{
    
    return self.frame.origin.x + self.frame.size.width;
    
}

/* 无实际意义，用处不大*/
-(void)setWyh_top:(CGFloat)wyh_top{}
-(void)setWyh_left:(CGFloat)wyh_left{}
-(void)setWyh_bottom:(CGFloat)wyh_bottom{};
-(void)setWyh_right:(CGFloat)wyh_right{};

-(void)setWyh_size:(CGSize)wyh_size{
    
    CGRect frame = self.frame;
    frame.size = wyh_size;
    self.frame = frame;
    
}

-(CGSize)wyh_size{
    
    return self.frame.size;
    
}

-(void)setWyh_centerX:(CGFloat)wyh_centerX{
    
    self.center = CGPointMake(wyh_centerX, self.center.y);
    
}

-(CGFloat)wyh_centerX{
    
    return self.center.x;
    
}

-(void)setWyh_centerY:(CGFloat)wyh_centerY{
    
    self.center = CGPointMake(self.center.x, wyh_centerY);
    
}

-(CGFloat)wyh_centerY{
    
    return self.center.y;
    
}



@end
