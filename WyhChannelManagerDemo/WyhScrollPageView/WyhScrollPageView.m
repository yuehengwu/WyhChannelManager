//
//  WyhScrollPageView.m
//  WyhPersonalCenter
//
//  Created by wyh on 2017/2/18.
//  Copyright © 2017年 wyh. All rights reserved.
//

#import "WyhScrollPageView.h"

@interface WyhScrollPageView ()

@property (nonatomic, strong) WyhSegmentView *segmentView;

@property (nonatomic, strong) WyhContentView *contentView;

@property (nonatomic, strong) WyhSegmentStyle *wyhStyle;

@end

@implementation WyhScrollPageView


-(instancetype)initWithFrame:(CGRect)frame
                       style:(WyhSegmentStyle *)style
                  titleArray:(NSArray *)titles
        parentViewController:(UIViewController *)parentVC
                    delegate:(id<WyhScrollPageDelegate>)delegate
{
    
    if (self = [super initWithFrame:frame]) {
        
        self.wyhStyle = !style ? self.wyhStyle : style;
        
        NSAssert(self.wyhStyle.segmentHeight!=0, @"设置的样式里segmentView的高度不得为0");
        
        CGRect segmentFrame = CGRectMake(frame.origin.x, 0, frame.size.width, self.wyhStyle.segmentHeight);
        CGRect contentFrame = CGRectMake(frame.origin.x,self.wyhStyle.segmentHeight, frame.size.width, frame.size.height - self.wyhStyle.segmentHeight);
        _segmentView = [[WyhSegmentView alloc]initWithFrame:segmentFrame style:style titleArray:titles parentViewController:parentVC delegate:delegate tapHandleBlock:^(WyhTitleView *wyhTitleLabel, NSUInteger index) {
            [self.contentView setContentOffSet:CGPointMake(self.contentView.bounds.size.width*index, 0) animated:YES];
        }];
        _contentView = [[WyhContentView alloc]initWithFrame:contentFrame SegmentView:_segmentView ParentViewController:parentVC Delegate:delegate];
        
        [self updateConstraints];
        
    }
    
    return self;
}

-(void)updateConstraints{
    
    [super updateConstraints];
    [self addSubview:self.segmentView];
    [self addSubview:self.contentView];
    
}

-(void)setContentOffSet:(CGPoint)offset animated:(BOOL)animated{
    
    [self.contentView setContentOffSet:offset animated:animated];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(WyhSegmentStyle *)wyhStyle{
    if (!_wyhStyle) {
        _wyhStyle = [[WyhSegmentStyle alloc]init];
    }
    return _wyhStyle;
}

@end
