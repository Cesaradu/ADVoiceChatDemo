//
//  ADMessageTopView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADMessageTopView.h"
#import "ADMessageHelper.h"

@interface ADMessageTopView ()

@property (nonatomic, weak) UILabel *nameLabel;
@property (nonatomic, weak) UILabel *timeLabel;
@property (nonatomic, weak) UIView *lineView;
@property (nonatomic, assign) BOOL isSender;

@end

@implementation ADMessageTopView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        //self.backgroundColor = [UIColor redColor];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.x       = 3;
    [self.nameLabel sizeToFit];
    self.nameLabel.centerY = self.height * 0.5;
    _nameLabel.width       = 58;
    
    [self.timeLabel sizeToFit];
    self.timeLabel.centerY = self.height * 0.5;
    if (_isSender) {
        _timeLabel.width = 70;
        self.timeLabel.x       = self.width - self.timeLabel.width - 3;
    } else {
        [_nameLabel sizeToFit];
        self.timeLabel.x       = self.nameLabel.width + 6;
        _timeLabel.width       = 40;
        [_timeLabel sizeToFit];
    }
}

- (void)messageSendName:(NSString *)name
               isSender:(BOOL)isSender
                   date:(NSInteger)date {
    // 时间改成服务器的时间
    _isSender = isSender;
    NSString *currentDate      = [ADMessageHelper timeFormatWithDate:date];
    if (isSender) {
        self.timeLabel.text    = currentDate;
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.nameLabel.hidden  = YES;
    } else {
        self.nameLabel.hidden  = NO;
        self.timeLabel.text    = currentDate;
        self.timeLabel.textAlignment = NSTextAlignmentLeft;
        self.nameLabel.text      = name;
        [_nameLabel sizeToFit];
        [_timeLabel sizeToFit];
    }
}

#pragma mark - Getter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        UILabel *label  = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentLeft;
        label.font      = [UIFont systemFontOfSize:14.0];
        label.textColor = ADRGB(0x929292);
        [self addSubview:label];
        _nameLabel      = label;
    }
    return _nameLabel;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.textAlignment = NSTextAlignmentRight;
        label.font     = [UIFont systemFontOfSize:14.0];
        label.textColor = ADRGB(0x929292);
        [self addSubview:label];
        _timeLabel     = label;
    }
    return _timeLabel;
}

- (UIView *)lineView {
    if (!_lineView) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = ADRGB(0xa8bd61);
        _lineView    = line;
    }
    return _lineView;
}


@end