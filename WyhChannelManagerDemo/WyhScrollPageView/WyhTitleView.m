//
//  WyhTitleView.m
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/17.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhTitleView.h"

@interface WyhTitleView ()

@property (nonatomic, strong) UIView *contentView;

@property (nonatomic, strong) UILabel *label;

@property (nonatomic, strong) WyhSegmentStyle *style;

@property (nonatomic, assign) CGSize labelSize;

@end

@implementation WyhTitleView

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        _isShowImage = NO; /*默认NO*/
        [self addSubview:self.label];/*为了setText*/
    }
    return self;
}

-(void)adjustSubViewsWithStyle:(WyhSegmentStyle *)style{
    
    self.viewHeight = self.viewHeight==0 ? 50 : self.viewHeight;/*默认50高*/
    
    CGRect contentframe = self.bounds;
    
    _style = style;
    
    self.contentView.frame = contentframe;
    self.label.frame = self.contentView.bounds;
    self.label.backgroundColor = !style.coverBackgroudColor?[UIColor whiteColor]:style.coverBackgroudColor;
    [self addSubview:self.contentView];
    [self.label removeFromSuperview];
    [self.contentView addSubview:self.label];
    
}

#pragma mark - setter 

-(void)setText:(NSString *)text{
    
    _text = text;
    
    self.label.text = text;
    
}

-(void)setCurrentTransformX:(CGFloat)currentTransformX{
    _currentTransformX = currentTransformX;
    self.transform = CGAffineTransformMakeScale(currentTransformX, currentTransformX);
}

-(void)setTextColor:(UIColor *)textColor{
    
    if (_textColor != textColor) {
        _textColor = textColor;
        
        self.label.textColor = textColor;
    }
    
}

#pragma mark - Lazy

-(CGSize)labelSize{
    
    //    NSAssert(self.viewHeight>0, @"设置的titleView高度不能小于0");
    
    CGRect rect = [self.label.text boundingRectWithSize:CGSizeMake(MAXFLOAT, self.viewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.font} context:nil];
    
    _labelSize = rect.size;
    
    return _labelSize;
}

-(UIView *)contentView{
    if (!_contentView) {
        _contentView = [[UIView alloc]init];
    }
    return _contentView;
}

-(UILabel *)label{
    if (!_label) {
        _label = [[UILabel alloc]init];
        _label.font = self.font;
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

-(UIFont *)font{
    if (!_font) {
        _font = [UIFont systemFontOfSize:14];
    }
    return _font;
}

-(CGRect)scrollBarFrame{
    
    CGRect frame;
    
    CGFloat scrollBarW = _style.scrollBarWidth==0 ? _labelSize.width : _style.scrollBarWidth; /*是否有自定义宽度*/
    CGFloat scrollBarH = _style.scrollBarHeight;
    CGFloat scrollBarX = self.bounds.size.width/2 - scrollBarW/2 + self.frame.origin.x;
    CGFloat scrollBarY = self.bounds.size.height;
    
    frame = CGRectMake(scrollBarX, scrollBarY, scrollBarW, scrollBarH);
    
    return frame;
    
}

//-(UIView *)scrollBar{
//    if (!_scrollBar) {
//        _scrollBar = [[UIView alloc]init];
//    }
//    return _scrollBar;
//}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
