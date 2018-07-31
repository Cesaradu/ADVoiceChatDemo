//
//  WechatListCell.m
//  Watch_Universal
//
//  Created by Adu on 2018/7/11.
//  Copyright © 2018年 Oliver. All rights reserved.
//

#import "WechatListCell.h"

@implementation WechatListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.headImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"default_boy"]];
        self.headImage.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:self.headImage];
        [self.headImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.mas_left).offset([self Suit:15]);
            make.centerY.equalTo(self.mas_centerY);
            make.width.height.mas_equalTo([self Suit:40]);
        }];
        
        self.nameLabel = [UILabel labelWithTitle:@"测试" AndColor:[UIColor colorWithHexString:@"000000" alpha:0.9] AndFont:[UIFont boldSystemFontOfSize:[self SuitFont:15]] AndAlignment:NSTextAlignmentLeft];
        [self addSubview:self.nameLabel];
        [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.headImage.mas_top);
            make.left.equalTo(self.headImage.mas_right).offset([self Suit:10]);
        }];
        
        self.msgLabel = [UILabel labelWithTitle:@"[语音]" AndColor:[UIColor colorWithHexString:@"000000" alpha:0.5] AndFont:[UIFont systemFontOfSize:[self SuitFont:13]] AndAlignment:NSTextAlignmentLeft];
        [self addSubview:self.msgLabel];
        [self.msgLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.headImage.mas_bottom);
            make.left.equalTo(self.nameLabel.mas_left);
        }];
        
        self.timeLabel = [UILabel labelWithTitle:@"11:35" AndColor:[UIColor colorWithHexString:@"000000" alpha:0.5] AndFont:[UIFont systemFontOfSize:[self SuitFont:13]] AndAlignment:NSTextAlignmentLeft];
        [self addSubview:self.timeLabel];
        [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.nameLabel.mas_centerY);
            make.right.equalTo(self.mas_right).offset([self Suit:-15]);
        }];
        
        self.line = [[UIView alloc] init];
        self.line.backgroundColor = [UIColor colorWithHexString:@"cdcdcd" alpha:1.0];
        [self addSubview:self.line];
        [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom);
            make.height.mas_equalTo(@0.5);
            make.left.equalTo(self.mas_left).offset([self Suit:15]);
            make.right.equalTo(self.mas_right).offset([self Suit:-15]);
        }];
        
    }
    return self;
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
