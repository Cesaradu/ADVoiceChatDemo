//
//  ADChatMessageVoiceCell.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatMessageVoiceCell.h"
#import "ADMessageModel.h"
#import "ADRecordManager.h"

@interface ADChatMessageVoiceCell ()

@property (nonatomic, strong) UIButton    *voiceButton;
@property (nonatomic, strong) UILabel     *durationLabel;
@property (nonatomic, strong) UIImageView *voiceIcon;
@property (nonatomic, strong) UIView      *redView;

@end

@implementation ADChatMessageVoiceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.voiceIcon];
        [self.contentView addSubview:self.durationLabel];
        [self.contentView addSubview:self.voiceButton];
        [self.contentView addSubview:self.redView];
    }
    return self;
}

- (void)setModelFrame:(ADMessageFrame *)modelFrame {
    [super setModelFrame:modelFrame];
    NSString *voicePath = [self mediaPath:modelFrame.model.mediaPath];
    self.durationLabel.text  = [NSString stringWithFormat:@"%ld''",[[ADRecordManager shareManager] durationWithAudio:[NSURL fileURLWithPath:voicePath]]];
    if (modelFrame.model.isSender) {  // sender
        self.durationLabel.textAlignment = NSTextAlignmentLeft;
        self.voiceIcon.image = [UIImage imageNamed:@"right-3"];
        UIImage *image1 = [UIImage imageNamed:@"right-1"];
        UIImage *image2 = [UIImage imageNamed:@"right-2"];
        UIImage *image3 = [UIImage imageNamed:@"right-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    } else {                          // receive
        self.durationLabel.textAlignment = NSTextAlignmentRight;
        self.voiceIcon.image = [UIImage imageNamed:@"left-3"];
        UIImage *image1 = [UIImage imageNamed:@"left-1"];
        UIImage *image2 = [UIImage imageNamed:@"left-2"];
        UIImage *image3 = [UIImage imageNamed:@"left-3"];
        self.voiceIcon.animationImages = @[image1, image2, image3];
    }
    self.voiceIcon.animationDuration = 0.8;
    if (modelFrame.model.message.status == ADMessageStatus_read) {
        self.redView.hidden  = YES;
    } else if (modelFrame.model.message.status == ADMessageStatus_unRead) {
        self.redView.hidden  = NO;
    }
    self.durationLabel.frame = modelFrame.durationLabelF;
    self.voiceIcon.frame     = modelFrame.voiceIconF;
    self.voiceButton.frame   = modelFrame.bubbleViewF;
    self.redView.frame       = modelFrame.redViewF;
    
}

// 文件路径
- (NSString *)mediaPath:(NSString *)originPath {
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[ADRecordManager shareManager] receiveVoicePathWithFileKey:name];
}

#pragma mark - respond Method
- (void)voiceButtonClicked:(UIButton *)voiceBtn {
    voiceBtn.selected = !voiceBtn.selected;
    [self routerEventWithName:ADRouterEventVoiceTapEventName
                     userInfo:@{MessageKey : self.modelFrame,
                                VoiceIcon  : self.voiceIcon,
                                RedView    : self.redView
                                }];
}

#pragma mark - Getter
- (UIButton *)voiceButton {
    if (nil == _voiceButton) {
        _voiceButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_voiceButton addTarget:self action:@selector(voiceButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _voiceButton;
}

- (UILabel *)durationLabel {
    if (nil == _durationLabel ) {
        _durationLabel = [[UILabel alloc] init];
        _durationLabel.font = MessageFont;
    }
    return _durationLabel;
}

- (UIImageView *)voiceIcon {
    if (nil == _voiceIcon) {
        _voiceIcon = [[UIImageView alloc] init];
    }
    return _voiceIcon;
}

- (UIView *)redView {
    if (nil == _redView) {
        _redView = [[UIView alloc] init];
        _redView.layer.masksToBounds = YES;
        _redView.layer.cornerRadius = 4;
        _redView.backgroundColor = ADRGB(0xf05e4b);
    }
    return _redView;
}

@end
