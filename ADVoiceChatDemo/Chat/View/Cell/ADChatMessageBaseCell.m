//
//  ADChatMessageBaseCell.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatMessageBaseCell.h"
#import "ADMessageModel.h"
#import "ADMessage.h"
#import "ADMessageTopView.h"

@interface ADChatMessageBaseCell ()


@end

@implementation ADChatMessageBaseCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = [UIColor clearColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UILongPressGestureRecognizer *longRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognizer:)];
        longRecognizer.minimumPressDuration = 0.5;
        [self addGestureRecognizer:longRecognizer];
    }
    return self;
}

#pragma mark - UI
- (void)setupUI {
    [self.contentView addSubview:self.bubbleView];
    [self.contentView addSubview:self.headImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.activityView];
    [self.contentView addSubview:self.retryButton];
}

#pragma mark - Getter and Setter
- (UILabel *)nameLabel {
    if (!_nameLabel) {
        _nameLabel = [UILabel labelWithColor:[UIColor colorWithHexString:@"000000" alpha:0.6] AndFont:[UIFont systemFontOfSize:13] AndAlignment:NSTextAlignmentCenter];
        _nameLabel.text = @"名字";
    }
    return _nameLabel;
}

- (ADHeadImageView *)headImageView {
    if (_headImageView == nil) {
        _headImageView = [[ADHeadImageView alloc] init];
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(headClicked)];
        [_headImageView addGestureRecognizer:tapGes];
    }
    return _headImageView;
}

- (UIImageView *)bubbleView {
    if (_bubbleView == nil) {
        _bubbleView = [[UIImageView alloc] init];
    }
    return _bubbleView;
}

- (UIActivityIndicatorView *)activityView {
    if (_activityView == nil) {
        _activityView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    }
    return _activityView;
}

- (UIButton *)retryButton {
    if (_retryButton == nil) {
        _retryButton = [[UIButton alloc] init];
        [_retryButton setImage:[UIImage imageNamed:@"button_retry_comment"] forState:UIControlStateNormal];
        [_retryButton addTarget:self action:@selector(retryButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _retryButton;
}

#pragma mark - Respond Method
- (void)retryButtonClick:(UIButton *)btn {
    if ([self.longPressDelegate respondsToSelector:@selector(reSendMessage:)]) {
        [self.longPressDelegate reSendMessage:self];
    }
}

- (void)setModelFrame:(ADMessageFrame *)modelFrame {
    _modelFrame = modelFrame;
    
    ADMessageModel *messageModel = modelFrame.model;
    self.nameLabel.frame = modelFrame.nameLabelF;
    self.headImageView.frame     = modelFrame.headImageViewF;
    self.bubbleView.frame        = modelFrame.bubbleViewF;
//    [self.headImageView.imageView sd_setImageWithURL:[NSURL URLWithString:messageModel.headImage] placeholderImage:[UIImage imageNamed:@"head_icon"]];
    self.nameLabel.text = messageModel.name;
    if (messageModel.isSender) {    // 发送者
        self.nameLabel.textAlignment = NSTextAlignmentRight;
        self.activityView.frame  = modelFrame.activityF;
        self.retryButton.frame   = modelFrame.retryButtonF;
        self.headImageView.imageView.image = [UIImage imageNamed:@"default_boy"];
        switch (modelFrame.model.message.deliveryState) { // 发送状态
            case ADMessageDeliveryState_Delivering:
            {
                [self.activityView setHidden:NO];
                [self.retryButton setHidden:YES];
                [self.activityView startAnimating];
            }
                break;
            case ADMessageDeliveryState_Delivered:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:YES];
            }
                break;
            case ADMessageDeliveryState_Failure:
            {
                [self.activityView stopAnimating];
                [self.activityView setHidden:YES];
                [self.retryButton setHidden:NO];
            }
                break;
            default:
                break;
        }
        if ([modelFrame.model.message.type isEqualToString:TypeFile] ||[modelFrame.model.message.type isEqualToString:TypePicText]) {
            self.bubbleView.image = [UIImage imageNamed:@"liaotianfile"];
        } else {
            self.bubbleView.image = [[UIImage imageNamed:@"liaotianbeijing2"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 10, 20) resizingMode:UIImageResizingModeStretch];
        }
    } else {    // 接收者
        self.headImageView.imageView.image = [UIImage imageNamed:@"default_girl"];
        self.nameLabel.textAlignment = NSTextAlignmentLeft;
        self.retryButton.hidden  = YES;
        self.bubbleView.image    = [[UIImage imageNamed:@"liaotianbeijing1"] resizableImageWithCapInsets:UIEdgeInsetsMake(20, 10, 10, 20) resizingMode:UIImageResizingModeStretch];
    }
}

- (void)headClicked {
    if ([self.longPressDelegate respondsToSelector:@selector(headImageClicked:)]) {
        [self.longPressDelegate headImageClicked:_modelFrame.model.message.from];
    }
}

#pragma mark - longPress delegate
- (void)longPressRecognizer:(UILongPressGestureRecognizer *)recognizer {
    if ([self.longPressDelegate respondsToSelector:@selector(longPress:)]) {
        [self.longPressDelegate longPress:recognizer];
    }
}

@end

