//
//  ViewController.m
//  仿AppStore首页跳转动画
//
//  Created by caimengnan on 2018/7/7.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"
#import "BottomView.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIView *myBottomView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) UIScrollView *scrollView;
//@property (nonatomic,strong) BottomView *bottomScrollView;
@end

@implementation ViewController


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.title = @"转场动画";
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.dataSource = @[@"fireman",@"meinv1",@"fengjing2"];
    
    [self.view addSubview:self.tableView];
    
}






- (UIScrollView *)scrollView
{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _scrollView.contentSize = CGSizeMake(SCREEN_WIDTH, 2 * SCREEN_HEIGHT);
        _scrollView.delegate = self;
        _scrollView.backgroundColor = [UIColor blueColor];
    }
    return _scrollView;
}


- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,SCREEN_WIDTH , SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"TableViewCell" bundle:nil] forCellReuseIdentifier:@"TableViewCell"];
        [_tableView registerClass:[MyCell class] forCellReuseIdentifier:@"MyCell"];
        
    }
    return _tableView;
}

- (UIView *)myBottomView
{
    if (_myBottomView == nil) {
        _myBottomView = [[UIView alloc]initWithFrame: CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        _myBottomView.backgroundColor = [UIColor clearColor];
        
        //添加毛玻璃
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:(UIBlurEffectStyleLight)];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc]initWithEffect:effect];
        effectView.frame = _myBottomView.frame;
        [_myBottomView addSubview:effectView];
        
    }
    return _myBottomView;
}

//- (BottomView *)bottomScrollView
//{
//    if (_bottomScrollView == nil) {
//        _bottomScrollView = [[BottomView alloc]initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT))];
//        _bottomScrollView.backgroundColor = [UIColor redColor];
//    }
//    return _bottomScrollView;
//}



#pragma mark -- UITableViewDelegate  UITableViewDataSource

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    cell.myImageView.clipsToBounds = YES;
    cell.myImageView.image = [UIImage imageNamed:self.dataSource[indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath{

    MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.3 animations:^{
        cell.bottomView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }];

    return YES;
}


- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
        MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [UIView animateWithDuration:0.3 animations:^{
            cell.bottomView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    
}

- (BOOL)prefersStatusBarHidden{
    return YES;
}


- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation{
    return UIStatusBarAnimationFade;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //隐藏状态栏
    
    
    //cell中bottomView的frame转换成self.view中的frame
    MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect transformFrame = [cell.bottomView convertRect:cell.bottomView.bounds toView:self.view];
    cell.bottomView.frame = transformFrame;
    
    //添加滑动视图
    BottomView *bottomScrollView = [[BottomView alloc]initWithFrame:(CGRectMake(padding, transformFrame.origin.y, cellWidth, IMGAEHEIGHT))];
    bottomScrollView.backgroundColor = [UIColor blueColor];
    
    //cell.bottomView添加到self.view上，方便进行frame转换动画
    [self.view addSubview:cell.bottomView];
    [self.view addSubview:bottomScrollView];
    [self.view insertSubview:cell.bottomView aboveSubview:bottomScrollView];

    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:(UIViewAnimationOptionAllowAnimatedContent) animations:^{
        [bottomScrollView changeFramesWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        cell.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH,IMGAEHEIGHT);
        cell.bottomView.layer.cornerRadius = 0.0;
        cell.myImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, IMGAEHEIGHT);
        cell.titleLabel.frame = CGRectMake(15, 15, 200, 60);
        cell.closeBtn.frame = CGRectMake(SCREEN_WIDTH-40, 20, 30, 30);
        cell.closeBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
        //frame转换完成后添加背景图，添加滚动视图，滚动视图上添加cell.bottomView
        [self.view addSubview:self.myBottomView];
        [self.view addSubview:bottomScrollView];
        [bottomScrollView addTopView:cell.bottomView];
        self.myBottomView.hidden = NO;
    }];


    //FIXME:返回操作
    CGRect currentRect = [cell.bottomView convertRect:cell.bottomView.bounds toView:self.view];
    __weak typeof(MyCell) *weakCell = cell;
    cell.closeActionCAllBack = ^{
        weakCell.bottomView.frame = currentRect;
        [self.view addSubview:weakCell.bottomView];
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [bottomScrollView changeFramesWithFrame:transformFrame];
            weakCell.bottomView.frame = transformFrame;
            weakCell.bottomView.layer.cornerRadius = 10.0;
            weakCell.myImageView.frame = CGRectMake(-20, -20, SCREEN_WIDTH, IMGAEHEIGHT);
            weakCell.closeBtn.frame = CGRectMake(weakCell.bottomView.frame.size.width-40, 20, 30, 30);
            weakCell.closeBtn.alpha = 0.0;
            weakCell.titleLabel.frame = CGRectMake(15, 15, 200, 60);
        } completion:^(BOOL finished) {
            weakCell.bottomView.frame = CGRectMake(20, 20, transformFrame.size.width, transformFrame.size.height);
            [weakCell.contentView addSubview:weakCell.bottomView];
            [bottomScrollView removeFromSuperview];
        }];
        self.myBottomView.hidden = YES;
    };
    
    
    //FIXME: 侧滑操作
    __weak typeof(self) weakSelf = self;
    bottomScrollView.edgeGestureCallBack = ^(UIScreenEdgePanGestureRecognizer *ges) {
        
        CGPoint currentPoint = [ges locationInView:weakSelf.myBottomView];
        CGFloat scale = 1 - (currentPoint.x * 0.3)/(SCREEN_WIDTH/2);
        
        if (scale >= 0.75) {
            
            cell.bottomView.transform = CGAffineTransformMakeScale(scale, scale);
            cell.bottomView.layer.cornerRadius = currentPoint.x * 20/SCREEN_WIDTH;
            
            cell.closeBtn.alpha = (scale-0.75)/0.25;
            
        } else if (scale < 0.75) {
            
            if (weakSelf.myBottomView.isHidden) {
                return;
            }
            
            weakSelf.myBottomView.hidden = YES;
            
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                cell.bottomView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                cell.bottomView.frame = transformFrame;
//                cell.closeBtn.frame = CGRectMake(cell.bottomView.frame.size.width-40, 20, 30, 30);
            } completion:^(BOOL finished) {
                cell.bottomView.frame = CGRectMake(20, 20, SCREEN_WIDTH-40,cellHeight - 40);
                [cell.contentView addSubview:cell.bottomView];
                
            }];
            
        }
        
        //手势取消或停止
        if (ges.state == UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.2 animations:^{
                cell.bottomView.transform = CGAffineTransformMakeScale(1, 1);
                cell.bottomView.layer.cornerRadius = 0;
                cell.closeBtn.alpha = 1.0;
            }];
        }
        
    };
    
    
    //FIXME: ScrollView滑动造成的closeBtn移动
    bottomScrollView.changeCloseBtnFrameCallBack = ^(CGFloat offset_Y) {
        
//        NSLog(@"%f",offset_Y);
        
        cell.closeBtn.frame = CGRectMake(SCREEN_WIDTH-40, 20 + offset_Y, 30, 30);
    };
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return nil;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

