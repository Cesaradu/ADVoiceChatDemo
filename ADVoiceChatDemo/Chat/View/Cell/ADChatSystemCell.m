//
//  ADChatSystemCell.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatSystemCell.h"
#import "ADMessageFrame.h"
#import "ADMessageModel.h"
#import "ADMessage.h"

#define labelFont [UIFont systemFontOfSize:11.0]

@interface ADChatSystemCell ()

@property (nonatomic, weak) UILabel *contentLabel;

@end

@implementation ADChatSystemCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID {
    ADChatSystemCell *cell = [[ADChatSystemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        UILabel *contentLabel = [[UILabel alloc] init];
        [self addSubview:contentLabel];
        self.contentLabel = contentLabel;
        self.backgroundColor           = [UIColor clearColor];
        self.selectionStyle            = UITableViewCellSelectionStyleNone;
        self.contentLabel.backgroundColor = ADRGB(0xd3d2d2);
        self.contentLabel.textColor       = [UIColor whiteColor];
        self.contentLabel.textAlignment   = NSTextAlignmentCenter;
        self.contentLabel.font            = [UIFont systemFontOfSize:11.0];
        self.contentLabel.layer.masksToBounds  = YES;
        self.contentLabel.layer.cornerRadius   = 4.0;
        self.contentLabel.width = [UIScreen mainScreen].bounds.size.width - 40;
        self.contentLabel.numberOfLines        = 0;
    }
    return self;
}

- (void)setMessageF:(ADMessageFrame *)messageF {
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size           = [messageF.model.message.content sizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 40 andFont:labelFont];
    if (size.width > width-40) {
        size.width = width - 40;
    }
    self.contentLabel.height = (int)size.height+3;
    self.contentLabel.width  = (int)size.width+20;// 这个地方不强制转换会有问题
    self.contentLabel.center = CGPointMake(width*0.5, (size.height+10)*0.5);
    
    _messageF            = messageF;
    self.contentLabel.text = messageF.model.message.content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

@end
