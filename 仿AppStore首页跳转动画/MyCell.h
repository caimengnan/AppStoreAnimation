//
//  MyCell.h
//  TransferAnimation
//
//  Created by caimengnan on 2018/7/7.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCell : UITableViewCell
@property (nonatomic,strong) UIView *bottomView;
@property (nonatomic,strong) UIImageView *myImageView;
@property (nonatomic,strong) UILabel *titleLabel;
@property (nonatomic,strong) UIButton *closeBtn;
@property (nonatomic,strong) UILabel *detailLabel;
@property (nonatomic,strong) UIScrollView *scrollView;

//关闭按钮的回调
@property (copy,nonatomic) void(^closeActionCAllBack)(void);

- (void)setUpFramesInCell;

@end
