//
//  ADChatMessageTextCell.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatMessageTextCell.h"
#import "ADMessageModel.h"
#import "ADFaceManager.h"

@interface ADChatMessageTextCell ()

@end

@implementation ADChatMessageTextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.chatLabel];
        __weak typeof(self) weadSelf = self;
        _chatLabel.urlLinkTapHandler = ^(KILabel *label, NSString *string, NSRange range) {
            [weadSelf urlSkip:[NSURL URLWithString:string]];
        };
    }
    return self;
}

#pragma mark - Private Method
- (void)setModelFrame:(ADMessageFrame *)modelFrame {
    [super setModelFrame:modelFrame];
    self.chatLabel.frame = modelFrame.chatLabelF;
    [self.chatLabel setAttributedText:[ADFaceManager transferMessageString:modelFrame.model.message.content font:self.chatLabel.font lineHeight:self.chatLabel.font.lineHeight]];
    //    self.chatLabel.text = modelFrame.model.content;
}

- (void)attemptOpenURL:(NSURL *)url {
    BOOL safariCompatible = [url.scheme isEqualToString:@"http"] || [url.scheme isEqualToString:@"https"];
    if (safariCompatible && [[UIApplication sharedApplication] canOpenURL:url]) {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"警示" message:@"您的链接无效" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)urlSkip:(NSURL *)url {
    [self routerEventWithName:ADRouterEventURLSkip
                     userInfo:@{@"url"   : url
                                }];
}

#pragma mark - Getter and Setter
- (KILabel *)chatLabel {
    if (nil == _chatLabel) {
        _chatLabel = [[KILabel alloc] init];
        _chatLabel.numberOfLines = 0;
        _chatLabel.font = MessageFont;
        _chatLabel.textColor = ADRGB(0x282724);
    }
    return _chatLabel;
}

@end
