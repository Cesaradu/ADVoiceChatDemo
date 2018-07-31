//
//  ADChatMessageSyeCell.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatMessageSyeCell.h"
#import "ADMessageFrame.h"
#import "ADMessageModel.h"
#import "ADMessage.h"

#define labelFont [UIFont systemFontOfSize:11.0]

@interface ADChatMessageSyeCell ()

@end

@implementation ADChatMessageSyeCell

+ (instancetype)cellWithTableView:(UITableView *)tableView reusableId:(NSString *)ID {
    ADChatMessageSyeCell *cell = [[ADChatMessageSyeCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor           = [UIColor greenColor];
        self.selectionStyle            = UITableViewCellSelectionStyleNone;
        self.textLabel.backgroundColor = ADRGB(0xd3d2d2);
        self.textLabel.textColor       = [UIColor whiteColor];
        self.textLabel.textAlignment   = NSTextAlignmentCenter;
        self.textLabel.font            = labelFont;
        self.textLabel.layer.masksToBounds  = YES;
        self.textLabel.layer.cornerRadius   = 5.0;
        self.textLabel.width = self.width - 40;
        self.textLabel.numberOfLines        = 0;
    }
    return self;
}

- (void)setMessageF:(ADMessageFrame *)messageF {
    _messageF            = messageF;
    self.textLabel.text = messageF.model.message.content;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    CGSize size           = [self.textLabel.text sizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width - 40 andFont:labelFont];
    if (size.width > width-40) {
        size.width = width - 40;
    }
    self.textLabel.height = (int)size.height;
    self.textLabel.width  = (int)size.width+20;// 这个地方不强制转换会有问题
    self.textLabel.center = CGPointMake(width*0.5, (size.height+10)*0.5);
}


@end
