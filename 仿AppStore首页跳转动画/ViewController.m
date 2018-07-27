//
//  ViewController.m
//  AppStore
//
//  Created by caimengnan on 2018/7/24.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"


@interface ViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) UIView *myBottomView;
@property (nonatomic,assign) CGRect tempFrame;
@property (nonatomic,assign) BOOL tag;
@end

@implementation ViewController


- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0 ,SCREEN_WIDTH , SCREEN_HEIGHT) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
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


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCell * cell = [tableView dequeueReusableCellWithIdentifier:@"MyCell"];
    if (cell == nil) {
        cell = [[MyCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyCell"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //点击事件
    [self changeStatusbar];
    
    MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    CGRect transformFrame = [cell.bottomScrollView convertRect:cell.bottomScrollView.bounds toView:self.view];
    cell.bottomScrollView.frame = transformFrame;
    
    [self.view addSubview:cell.bottomScrollView];
    
    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:(UIViewAnimationOptionAllowAnimatedContent) animations:^{
        [cell transFormSubViewsFrame];
    } completion:^(BOOL finished) {
        //frame转换完成后添加背景图
        self.myBottomView.hidden = NO;;
    }];
    
    
    //返回操作
    __weak typeof(MyCell) *weakCell = cell;
    cell.closeActionCAllBack = ^{
        
        [self changeStatusbar];
        
        self.myBottomView.hidden = YES;
        
        CGRect currentRect = [weakCell.bottomView convertRect:weakCell.bottomView.bounds toView:self.view];
        weakCell.bottomView.frame = currentRect;
        
        //把bottomView的父视图修改为self.view
        [self.view addSubview:weakCell.bottomView];
        
        [UIView animateWithDuration:1.0 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            [weakCell shrinkSubViewsFrameWith:transformFrame];
        } completion:^(BOOL finished) {
            [weakCell resetFrames];
            
        }];
        
    };
    
    
    //侧滑操作
    cell.edgeGestureCallBack = ^(CGFloat scale, CGFloat distance, UIGestureRecognizerState state) {
        
        if (scale >= 0.75) {
            
            NSLog(@"hahaaaaa");
            
            weakCell.bottomScrollView.transform = CGAffineTransformMakeScale(scale, scale);
            weakCell.bottomScrollView.layer.cornerRadius = distance * 20/SCREEN_WIDTH;
            weakCell.bottomScrollView.clipsToBounds = YES;
            weakCell.closeBtn.alpha = (scale-0.75)/0.25;
            
        } else if (scale < 0.75) {
            if (self.myBottomView.isHidden) {
                return;
            }
            self.myBottomView.hidden = YES;
            
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                
                weakCell.bottomScrollView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                weakCell.bottomScrollView.frame = transformFrame;
                
                weakCell.myImageView.frame = CGRectMake(-padding, -padding, SCREEN_WIDTH, IMGAEHEIGHT);
                weakCell.closeBtn.frame = CGRectMake(cellWidth-40, 20, 30, 30);
                [weakCell.bottomScrollView setContentOffset:(CGPointMake(0, 0)) animated:YES];
                
            } completion:^(BOOL finished) {
                
                weakCell.bottomScrollView.frame = CGRectMake(padding, padding, cellWidth, 375);
                weakCell.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 375);
                weakCell.myImageView.frame = CGRectMake(-padding, -padding, SCREEN_WIDTH, IMGAEHEIGHT);
                weakCell.closeBtn.frame = CGRectMake(cellWidth-40, 20, 30, 30);
                
                [weakCell.bottomScrollView addSubview:weakCell.bottomView];
                [weakCell.contentView addSubview:weakCell.bottomScrollView];
                
                
            }];
            
        }
        
        //手势取消或停止
        if (state == UIGestureRecognizerStateCancelled || state == UIGestureRecognizerStateEnded) {
            
            [UIView animateWithDuration:0.2 animations:^{
                weakCell.bottomScrollView.transform = CGAffineTransformMakeScale(1, 1);
                weakCell.bottomScrollView.layer.cornerRadius = 0;
                weakCell.closeBtn.alpha = 1.0;
            }];
        }
        
        
    };
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    [self.view addSubview:self.myBottomView];
    self.myBottomView.hidden = YES;
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation
{
    return UIStatusBarAnimationFade;
}

- (void)changeStatusbar {
    _tag = !_tag;
    [self setNeedsStatusBarAppearanceUpdate];
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
