//
//  MyCell.m
//  TransferAnimation
//
//  Created by caimengnan on 2018/7/7.
//  Copyright © 2018年 王双龙. All rights reserved.
//

#import "MyCell.h"

//#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
//#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation MyCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    [self addSubViews];
    return self;
}



- (void)addSubViews{
    
    self.bottomView = [[UIView alloc]init];
    
    self.bottomView.backgroundColor = [UIColor whiteColor];
    self.bottomView.clipsToBounds = YES;
    self.bottomView.layer.cornerRadius = 8.0;
    self.bottomView.userInteractionEnabled = YES;
    
    
    
    self.myImageView = [[UIImageView alloc]init];
    self.myImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.myImageView.clipsToBounds = YES;
    
    self.titleLabel = [[UILabel alloc]init];
    self.titleLabel.text = @"冠军之战，东部豪门对阵西部黑马";
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.font = [UIFont systemFontOfSize:24.0];
    
    self.closeBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self.closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:(UIControlStateNormal)];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    self.detailLabel = [[UILabel alloc]init];
    self.detailLabel.text = @"世界杯眼看就接近尾声，借着这个间歇期，赶紧吐槽一下那些惹恼球迷的诡异广告。网友们的吐槽，比这些复读机式的脑残广告词要精彩有趣得多：恕我直言，本来有你们的APP，看了那个垃圾广告后卸载了；这种玩意还留着，就是对人类审美的犯罪；你们的广告属于大学老师讲的最垃圾的案例；同仇敌忾、声嘶力竭的假球迷，活脱脱一群刚从传销窝点跑出来、还要直接跟传销头子讨薪的受害者；我不知道，我不知道，不为什么，不为什么，就想抽那张大脸，顺便把电视砸了... 7月13日的凤凰网体育《运动汇》如期与您见面，感谢您的关注";
    self.detailLabel.numberOfLines = 0;
    
    [self setUpFramesInCell];
    
    [self.contentView addSubview:self.bottomView];
    [self.bottomView addSubview:self.myImageView];
    [self.bottomView addSubview:self.titleLabel];
    [self.bottomView addSubview:self.closeBtn];
    [self.bottomView addSubview:self.detailLabel];
    
}

- (void)setUpFramesInCell{
    self.bottomView.frame = CGRectMake(padding, padding, cellWidth,415 - 2 * padding);
    self.myImageView.frame = CGRectMake(-padding, -padding, SCREEN_WIDTH, IMGAEHEIGHT);
    self.closeBtn.frame = CGRectMake(self.bottomView.frame.size.width-40, padding, 30, 30);
    self.closeBtn.alpha = 0.0;
    self.titleLabel.frame = CGRectMake(15, 15, 200, 60);
    self.detailLabel.frame = CGRectMake(padding, IMGAEHEIGHT, cellWidth, 200);
}


//关闭操作
- (void)closeAction{
    self.closeActionCAllBack();
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
