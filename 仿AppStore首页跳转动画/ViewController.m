//
//  ViewController.m
//  仿AppStore首页跳转动画
//
//  Created by caimengnan on 2018/7/7.
//  Copyright © 2018年 frameworkdemo. All rights reserved.
//

#import "ViewController.h"
#import "MyCell.h"

@interface ViewController () <UITableViewDataSource, UITableViewDelegate,UIScrollViewDelegate>
@property (nonatomic,strong) UIView *myBottomView;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic,strong) NSArray *dataSource;
@property (nonatomic,strong) UIScrollView *scrollView;
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
    
    UIView *headerView = [[UIView alloc]initWithFrame:(CGRectMake(0, 0, SCREEN_WIDTH, 300))];
    headerView.backgroundColor = [UIColor redColor];
    
    [self.view addSubview:self.tableView];
//    [self.scrollView addSubview:self.tableView];
//    [self.scrollView addSubview:headerView];
    
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

    NSLog(@"按下");

    MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [UIView animateWithDuration:0.3 animations:^{
        cell.bottomView.transform = CGAffineTransformMakeScale(0.95, 0.95);
    }];

    return YES;
}


- (void)tableView:(UITableView *)tableView didUnhighlightRowAtIndexPath:(NSIndexPath *)indexPath {
    
        NSLog(@"song kai");
        MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        [UIView animateWithDuration:0.3 animations:^{
            cell.bottomView.transform = CGAffineTransformMakeScale(1.0, 1.0);
        }];
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    
    //cell中bottomView的frame转换成self.view中的frame
    CGRect transformFrame = [cell.bottomView convertRect:cell.bottomView.bounds toView:self.view];
    cell.bottomView.frame = transformFrame;
    [self.view addSubview:cell.bottomView];

    [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:(UIViewAnimationOptionAllowAnimatedContent) animations:^{
        cell.bottomView.frame = CGRectMake(0, 0, SCREEN_WIDTH,SCREEN_HEIGHT);
        cell.bottomView.layer.cornerRadius = 0.0;
        cell.myImageView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*491/375);
        cell.titleLabel.frame = CGRectMake(15, 15, 200, 60);
        cell.closeBtn.frame = CGRectMake(cell.bottomView.frame.size.width-40, 20, 30, 30);
        cell.closeBtn.alpha = 1.0;
    } completion:^(BOOL finished) {
        [self.view insertSubview:self.myBottomView belowSubview:cell.bottomView];
        self.myBottomView.hidden = NO;
    }];


    //FIXME:返回操作
    __weak typeof(MyCell) *weakCell = cell;
    cell.closeActionCAllBack = ^{
        
        [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            weakCell.bottomView.frame = transformFrame;
            weakCell.bottomView.layer.cornerRadius = 10.0;
            weakCell.myImageView.frame = CGRectMake(-20, -20, SCREEN_WIDTH, SCREEN_WIDTH*491/375);
            weakCell.closeBtn.frame = CGRectMake(cell.bottomView.frame.size.width-40, 20, 30, 30);
            weakCell.closeBtn.alpha = 0.0;
            weakCell.titleLabel.frame = CGRectMake(15, 15, 200, 60);
        } completion:^(BOOL finished) {
            weakCell.bottomView.frame = CGRectMake(20, 20, transformFrame.size.width, transformFrame.size.height);
            [weakCell.contentView addSubview:weakCell.bottomView];
        }];
        
        self.myBottomView.hidden = YES;
        
    };
    
    //FIXME: 侧滑操作
    __weak typeof(self) weakSelf = self;
    cell.edgeGestureCallBack = ^(UIScreenEdgePanGestureRecognizer *ges) {
        
        CGPoint currentPoint = [ges locationInView:weakSelf.myBottomView];
        CGFloat scale = 1 - (currentPoint.x * 0.3)/(SCREEN_WIDTH/2);
        
        if (scale >= 0.75) {
            
            weakCell.bottomView.transform = CGAffineTransformMakeScale(scale, scale);
            weakCell.bottomView.layer.cornerRadius = currentPoint.x * 20/SCREEN_WIDTH;
            
            weakCell.closeBtn.alpha = (scale-0.75)/0.25;
            
        } else if (scale < 0.75) {
            
            if (weakSelf.myBottomView.isHidden) {
                return;
            }
            
            weakSelf.myBottomView.hidden = YES;
            
            [UIView animateWithDuration:0.7 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:0.5 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
                weakCell.bottomView.transform = CGAffineTransformMakeScale(1.0, 1.0);
                weakCell.bottomView.frame = transformFrame;
                weakCell.closeBtn.frame = CGRectMake(cell.bottomView.frame.size.width-40, 20, 30, 30);
            } completion:^(BOOL finished) {
                weakCell.bottomView.frame = CGRectMake(20, 20, SCREEN_WIDTH-40,415 - 40);
                [weakCell.contentView addSubview:weakCell.bottomView];
                
            }];
            
        }
        
        //手势取消或停止
        if (ges.state == UIGestureRecognizerStateCancelled || ges.state == UIGestureRecognizerStateEnded) {
            [UIView animateWithDuration:0.2 animations:^{
                weakCell.bottomView.transform = CGAffineTransformMakeScale(1, 1);
                weakCell.bottomView.layer.cornerRadius = 0;
                weakCell.closeBtn.alpha = 1.0;
            }];
        }
        
    };
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 415;
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

