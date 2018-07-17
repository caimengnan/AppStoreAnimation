//
//  BottomView.h
//  仿AppStore首页跳转动画
//
//  Created by caimengnan on 2018/7/16.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BottomView : UIView
@property (nonatomic,strong) UIScrollView *scrollView;

//滚动视图的contentsize
@property (nonatomic,assign) CGSize contentSize;

//偏移量
@property (nonatomic,assign) UIEdgeInsets contentInset;

//添加顶部视图
- (void)addTopView:(UIView *)topView;

//调整frame
- (void)changeFramesWithFrame:(CGRect)transformFrame;


//右滑手势
@property (copy,nonatomic) void(^edgeGestureCallBack)(UIScreenEdgePanGestureRecognizer *ges);
//滑动时改变cell上关闭按钮的位置
@property (copy,nonatomic) void(^changeCloseBtnFrameCallBack)(CGFloat offset_Y);

@end
