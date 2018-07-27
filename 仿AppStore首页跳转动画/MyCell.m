//
//  MyCell.m
//  AppStore
//
//  Created by caimengnan on 2018/7/24.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

#import "MyCell.h"


@implementation MyCell
{
    CGFloat offset_Y;
    CGPoint start_Y;
    CGPoint end_Y;
    UIGestureRecognizerState gesState;
    BOOL isSuspend;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self addSubViews];
    return self;
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event{
    id hitView = [super hitTest:point withEvent:event];  //被点击视图
    if (hitView != self) {
        return self;
    }
    return [super hitTest:point withEvent:event];
}


//添加子控件
- (void)addSubViews {
    
    isSuspend = YES;
    
    self.backgroundColor = [UIColor yellowColor];
    self.clipsToBounds = YES;
    
    self.bottomScrollView = [[UIScrollView alloc]initWithFrame:(CGRectMake(padding, padding, cellWidth, 375))];
    self.bottomScrollView.scrollIndicatorInsets = UIEdgeInsetsMake(IMGAEHEIGHT, 0, 0, 0);
    self.bottomScrollView.contentSize = CGSizeMake(cellWidth, 2 * SCREEN_HEIGHT);
    self.bottomScrollView.scrollEnabled = NO;
    self.bottomScrollView.delegate = self;
    self.bottomScrollView.bounces = NO;
    self.bottomScrollView.backgroundColor = [UIColor whiteColor];
    self.bottomScrollView.layer.cornerRadius = 10.0;
    [self addSubview:self.bottomScrollView];
    
    //监听scrollView的偏移量
    [self.bottomScrollView addObserver:self forKeyPath:@"contentOffset" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    [self addGestureToScrollView];
    
//    [self addObserver:self forKeyPath:@"moveTrack" options:NSKeyValueObservingOptionNew context:nil];
    
    
    self.contentLabel = [[UILabel alloc]init];
    self.contentLabel.frame = CGRectMake(20, IMGAEHEIGHT+10, SCREEN_WIDTH - 2*padding, 150);
    self.contentLabel.text = @"美国载人航天事业的尴尬境地是从其航天飞机退役开始的。没有了航天飞机，NASA仍要保障国际空间站的人员运输，策略只能是付高额票价购买俄罗斯“联盟”号的运送服务。为了不受制于人，NASA早已启动了一系列制造下一代航天载具的计划，并向本国的商业企业公开招标。";
    self.contentLabel.numberOfLines = 0;
    [self.bottomScrollView addSubview:self.contentLabel];
    
    
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.closeBtn.frame = CGRectMake(cellWidth-40, 20, 30, 30);
    [self.closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:(UIControlStateNormal)];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
    //在cell中是隐藏状态
    self.closeBtn.hidden = YES;
    [self.bottomScrollView addSubview:self.closeBtn];
    
    
    self.bottomView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, IMGAEHEIGHT))];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.clipsToBounds = YES;
    [self.bottomScrollView addSubview:self.bottomView];
    
    self.myImageView = [[UIImageView alloc]init];
    self.myImageView.frame = CGRectMake(-padding, -padding, SCREEN_WIDTH, IMGAEHEIGHT);
    self.myImageView.clipsToBounds = YES;
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.image = [UIImage imageNamed:@"meinv1.jpg"];
    [self.bottomView addSubview:self.myImageView];
    
    //关闭按钮放在bottomView上边
    [self.bottomScrollView insertSubview:self.closeBtn aboveSubview:self.bottomView];
    
    
}

//侧滑手势添加到self.bottomScrollView上
- (void)addGestureToScrollView {
    UIScreenEdgePanGestureRecognizer *edgGesture = [[UIScreenEdgePanGestureRecognizer alloc]initWithTarget:self action:@selector(edgGesAction:)];
    edgGesture.edges = UIRectEdgeLeft;
    [self.bottomScrollView addGestureRecognizer:edgGesture];
}

#pragma mark - 点击cell后 视图伸展开
- (void)transFormSubViewsFrame
{
    self.bottomScrollView.scrollEnabled = YES;
    self.bottomScrollView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
    self.bottomScrollView.layer.cornerRadius = 0.0;
    self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, IMGAEHEIGHT);
    self.myImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, IMGAEHEIGHT);
    self.closeBtn.frame = CGRectMake(SCREEN_WIDTH-40, 20, 30, 30);
    self.closeBtn.hidden = NO;
    self.closeBtn.alpha = 1.0;
    [self.bottomScrollView insertSubview:self.closeBtn aboveSubview:self.bottomView];
}

#pragma mark - 点击关闭后 视图收缩
- (void)shrinkSubViewsFrameWith:(CGRect)transformedFrame
{
    self.bottomScrollView.scrollEnabled = YES;
    self.bottomScrollView.frame = transformedFrame;
    self.bottomScrollView.layer.cornerRadius = 10.0;
    self.bottomView.frame = transformedFrame;
    self.bottomView.layer.cornerRadius = 10.0;
    self.myImageView.frame = CGRectMake(-padding, -padding, SCREEN_WIDTH, IMGAEHEIGHT);
    self.closeBtn.frame = CGRectMake(cellWidth-40, 20 + offset_Y, 30, 30);
    self.closeBtn.hidden = YES;
}

//视图收缩完成后 恢复到在cell中的位置
- (void)resetFrames {
    
    self.bottomScrollView.frame = CGRectMake(padding, padding, cellWidth, 375);
    self.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 375);
    self.bottomView.layer.cornerRadius = 0;
    self.myImageView.frame = CGRectMake(-padding, -padding, SCREEN_WIDTH, IMGAEHEIGHT);
    self.closeBtn.frame = CGRectMake(cellWidth-40, 20, 30, 30);
    
    //原来在self.view上，现在父视图改为self.bottomScrollView
    [self.bottomScrollView addSubview:self.bottomView];
    [self.contentView addSubview:self.bottomScrollView];
    [self.bottomScrollView setContentOffset:(CGPointMake(0, 0)) animated:NO];
    [self.bottomScrollView insertSubview:self.closeBtn aboveSubview:self.bottomView];
    
}

#pragma mark - 点击关闭
- (void)closeAction{
    self.closeActionCAllBack();
}

#pragma mark -侧滑手势
//侧滑操作
- (void)edgGesAction:(UIScreenEdgePanGestureRecognizer *)ges{
    
    CGPoint currentPoint = [ges locationInView:self.superview];
    CGFloat scale = 1 - (currentPoint.x * 0.3)/(SCREEN_WIDTH/2);
    
    self.edgeGestureCallBack(scale,currentPoint.x,ges.state);
}

#pragma mark - UIScrollView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat offSet_Y = scrollView.contentOffset.y;
    offset_Y = offSet_Y;
    self.closeBtn.frame = CGRectMake(SCREEN_WIDTH-40, 20 + offSet_Y, 30, 30);
    
    scrollView.bounces = NO;
    if (offSet_Y > 0) {
        isSuspend = NO;
    } else {
        self.bottomView.frame = CGRectMake(0, offSet_Y, SCREEN_WIDTH, IMGAEHEIGHT);
        isSuspend = YES;
    }
    
    if (offSet_Y <= (IMGAEHEIGHT - 15 - 30)) {
        [self.closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:(UIControlStateNormal)];
    } else {
        [self.closeBtn setImage:[UIImage imageNamed:@"取消"] forState:(UIControlStateNormal)];
    }
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    CGPoint point = [self.bottomScrollView.panGestureRecognizer locationInView:self.bottomScrollView];
    gesState = UIGestureRecognizerStateBegan;
    start_Y = point;
    [self gestureCallBack:gesState];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    CGPoint point = [self.bottomScrollView.panGestureRecognizer locationInView:self.bottomScrollView];
    gesState = UIGestureRecognizerStateCancelled;
    end_Y = point;
    [self gestureCallBack:gesState];
}



- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{

    if (object == self.bottomScrollView) {
        [self gestureCallBack:gesState];
    }
    
}

- (void)gestureCallBack:(UIGestureRecognizerState )state {
    
    CGPoint point1 = [self.bottomScrollView.panGestureRecognizer locationInView:self.bottomScrollView];
    NSLog(@"%d",isSuspend);
    
    if (isSuspend) {  //如果是悬浮状态 说明是下拉
        NSLog(@"下拉");
    } else {
        NSLog(@"上拉");
        return;
    }
    
    
    CGFloat currentPoint = point1.y - start_Y.y;
    CGFloat scale = 1 - (currentPoint * 0.3)/(SCREEN_WIDTH/2);
    
    NSLog(@"比例：%f",scale);
    if (scale >= 1.0) {
        return;
    }
    self.edgeGestureCallBack(scale,currentPoint,gesState);
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
