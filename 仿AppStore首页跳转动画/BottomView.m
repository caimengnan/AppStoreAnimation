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

@property (nonatomic,strong) UIView *tempView;

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
    self.scrollView.backgroundColor = [UIColor whiteColor];
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
    self.tempView = topView;
    topView.frame = CGRectMake(0, -IMGAEHEIGHT, SCREEN_WIDTH, IMGAEHEIGHT);
    UILabel *subLabel = [[UILabel alloc]initWithFrame:(CGRectMake(20, 0, topView.frame.size.width-40, 150))];
    subLabel.text = @"美国载人航天事业的尴尬境地是从其航天飞机退役开始的。没有了航天飞机，NASA仍要保障国际空间站的人员运输，策略只能是付高额票价购买俄罗斯“联盟”号的运送服务。为了不受制于人，NASA早已启动了一系列制造下一代航天载具的计划，并向本国的商业企业公开招标。";
    subLabel.numberOfLines = 0;
    [self.scrollView addSubview:subLabel];
    [self.scrollView addSubview:topView];
    
//    [self addObserver:self.tempView forKeyPath:@"frame" options:(NSKeyValueObservingOptionNew) context:nil];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    id hitView = [super hitTest:point withEvent:event];
    if ([hitView isKindOfClass:[UIButton class]]) {
        NSLog(@"按钮");
        return hitView;
    } else {
        NSLog(@"其他");
        return [super hitTest:point withEvent:event];
    }
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
    if (offSet_Y <= -IMGAEHEIGHT) {
        self.tempView.frame = CGRectMake(tempFrame.origin.x, offSet_Y, tempFrame.size.width, tempFrame.size.height);
    }
    
    //回调偏移量以更改closeBtn的位置
    self.changeCloseBtnFrameCallBack(offSet_Y+IMGAEHEIGHT);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if ([[NSString stringWithFormat:@"%f",scrollView.contentOffset.y] integerValue] <= [[NSString stringWithFormat:@"%f",-IMGAEHEIGHT] integerValue]) {
        scrollView.bounces = NO;
    }
}

@end
