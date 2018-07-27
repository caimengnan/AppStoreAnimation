//
//  MyCell.h
//  AppStore
//
//  Created by caimengnan on 2018/7/24.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MyCellCloseDelegate <NSObject>

- (void)closeAction;

@end

@interface MyCell : UITableViewCell<UIScrollViewDelegate>

@property (nonatomic,strong) UIScrollView *bottomScrollView;
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIImageView *myImageView;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UILabel *contentLabel;
@property (nonatomic,assign) CGFloat moveTrack;
@property (nonatomic,weak) id<MyCellCloseDelegate>delegate;

//右滑手势   传递滑动距离、比例、手势状态
@property (copy,nonatomic) void(^edgeGestureCallBack)(CGFloat scale,CGFloat distance,UIGestureRecognizerState state);

//点击cell后 视图伸展开
- (void)transFormSubViewsFrame;
//点击关闭后 视图收缩
- (void)shrinkSubViewsFrameWith:(CGRect)transformedFrame;
//视图收缩完成后 恢复到在cell中的位置
- (void)resetFrames;
//关闭按钮的回调
@property (copy,nonatomic) void(^closeActionCAllBack)(void);
@end
