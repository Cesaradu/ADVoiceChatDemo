//
//  WechatListCell.h
//  Watch_Universal
//
//  Created by Adu on 2018/7/11.
//  Copyright © 2018年 Oliver. All rights reserved.
//

#import "BaseTableCell.h"

@interface WechatListCell : BaseTableCell

@property (nonatomic, strong) UIImageView *headImage;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIView *line;

@end
