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
    self.scrollView.contentInset = contentInset;
    //滚动条位置
    self.scrollView.scrollIndicatorInsets = contentInset;
}

- (void)setUpSubViews{
    self.scrollView = [[UIScrollView alloc]init];
    self.scrollView.frame = self.bounds;
    self.scrollView.contentInset = UIEdgeInsetsMake(IMGAEHEIGHT, 0, 0, 0);
    self.scrollView.scrollIndicatorInsets = UIEdgeInsetsMake(IMGAEHEIGHT, 0, 0, 0);
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 2 * SCREEN_HEIGHT);
    self.scrollView.backgroundColor = [UIColor yellowColor];
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
    
//    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
//    [self.closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:(UIControlStateNormal)];
//    self.closeBtn.frame = CGRectMake(self.bounds.size.width-40, padding, 30, 30);
//    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
//    [self addSubview:self.closeBtn];
    
    UIScreenEdgePanGestureRecognizer *edgGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgGesAction:)];
    edgGesture.edges = UIRectEdgeLeft;
    [self addGestureRecognizer:edgGesture];
    
}


//添加顶部视图
- (void)addTopView:(UIView *)topView {
    topView.tag = 101;
    tempFrame = topView.frame;
    topView.frame = CGRectMake(0, -IMGAEHEIGHT, SCREEN_WIDTH, IMGAEHEIGHT);
    NSLog(@"self.scrollView.contentInset: %f",self.scrollView.contentInset.top);
    
    UIView *subView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, 50, 50))];
    subView.backgroundColor = [UIColor redColor];
    
    [self.scrollView addSubview:subView];
    [self.scrollView addSubview:topView];
    
}


//调整frame
- (void)changeFramesWithFrame:(CGRect)transformFrame{
    self.frame = transformFrame;
    self.scrollView.frame = CGRectMake(0, 0, transformFrame.size.width, transformFrame.size.height);
}



//侧滑操作
- (void)edgGesAction:(UIScreenEdgePanGestureRecognizer *)ges{
    self.edgeGestureCallBack(ges);
}


//UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat offSet_Y = scrollView.contentOffset.y;
    scrollView.bounces = YES;
    NSLog(@"%f",offSet_Y);
    if (offSet_Y <= -IMGAEHEIGHT) {
        UIView *headView = [self viewWithTag:101];
        headView.frame = CGRectMake(tempFrame.origin.x, offSet_Y, tempFrame.size.width, tempFrame.size.height);
    }
    
    //回调偏移量以更改closeBtn的位置
    self.changeCloseBtnFrameCallBack(offSet_Y+IMGAEHEIGHT);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y <= -IMGAEHEIGHT) {
        scrollView.bounces = NO;
    }
}

@end
