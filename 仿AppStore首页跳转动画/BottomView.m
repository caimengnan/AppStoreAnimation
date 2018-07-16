//
//  BottomView.m
//  仿AppStore首页跳转动画
//
//  Created by caimengnan on 2018/7/16.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

#import "BottomView.h"


@interface BottomView()<UIScrollViewDelegate>
{
    CGRect tempFrame;
}
@end

@implementation BottomView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    [self setUpSubViews];
    return self;
}


- (void)setContentSize:(CGSize)contentSize{
    _contentSize = contentSize;
//    CGSizeMake(SCREEN_WIDTH, 2 * SCREEN_HEIGHT);
    self.scrollView.contentSize = contentSize;
}


- (void)setContentInset:(UIEdgeInsets)contentInset{
    _contentInset = contentInset;
//    UIEdgeInsetsMake(200, 0, 0, 0)
    self.scrollView.contentInset = contentInset;
    //滚动条位置
    self.scrollView.scrollIndicatorInsets = contentInset;
}

- (void)setUpSubViews{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = self.frame;
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}


//添加顶部视图
- (void)addTopView:(UIView *)topView {
    topView.tag = 101;
    tempFrame = topView.frame;
    [self.scrollView addSubview:topView];
    
}

//UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSet_Y = scrollView.contentOffset.y;
    scrollView.bounces = YES;
    if (offSet_Y <= -self.contentInset.top) {
        UIView *headView = [self viewWithTag:101];
        headView.frame = CGRectMake(tempFrame.origin.x, offSet_Y, tempFrame.size.width, tempFrame.size.height);
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -self.contentInset.top) {
        scrollView.bounces = NO;
    }
}

@end
