//
//  ADChatMessageImageCell.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatMessageImageCell.h"
#import "ADMediaManager.h"
#import "ADMessageModel.h"
#import "ADMessage.h"
#import "ADFileTool.h"
#import "ADMessageHelper.h"

@interface ADChatMessageImageCell ()

@property (nonatomic, strong) UIButton *imageBtn;

@end

@implementation ADChatMessageImageCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageBtn];
    }
    return self;
}

#pragma mark - Private Method
- (void)setModelFrame:(ADMessageFrame *)modelFrame {
    [super setModelFrame:modelFrame];
    
    ADMediaManager *manager = [ADMediaManager sharedManager];
    UIImage *image = [manager imageWithLocalPath:[manager imagePathWithName:modelFrame.model.mediaPath.lastPathComponent]];
    self.imageBtn.frame = modelFrame.picViewF;
    self.bubbleView.userInteractionEnabled = _imageBtn.imageView.image != nil;
    self.bubbleView.image = nil;
    if (modelFrame.model.isSender) {    // 发送者
        UIImage *arrowImage = [manager arrowMeImage:image size:modelFrame.picViewF.size mediaPath:modelFrame.model.mediaPath isSender:modelFrame.model.isSender];
        [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
    } else {
        NSString *orgImgPath = [manager originImgPath:modelFrame];
        if ([ADFileTool fileExistsAtPath:orgImgPath]) {
            UIImage *orgImg = [manager imageWithLocalPath:orgImgPath];
            UIImage *arrowImage = [manager arrowMeImage:orgImg size:modelFrame.picViewF.size mediaPath:orgImgPath isSender:modelFrame.model.isSender];
            [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
        } else {
            UIImage *arrowImage = [manager arrowMeImage:image size:modelFrame.picViewF.size mediaPath:modelFrame.model.mediaPath isSender:modelFrame.model.isSender];
            [self.imageBtn setBackgroundImage:arrowImage forState:UIControlStateNormal];
        }
    }
}

- (void)imageBtnClick:(UIButton *)btn {
    if (btn.currentBackgroundImage == nil) {
        return;
    }
    CGRect smallRect = [ADMessageHelper photoFramInWindow:btn];
    CGRect bigRect   = [ADMessageHelper photoLargerInWindow:btn];
    NSValue *smallValue = [NSValue valueWithCGRect:smallRect];
    NSValue *bigValue   = [NSValue valueWithCGRect:bigRect];
    [self routerEventWithName:ADRouterEventImageTapEventName
                     userInfo:@{MessageKey   : self.modelFrame,
                                @"smallRect" : smallValue,
                                @"bigRect"   : bigValue
                                }];
}

#pragma mark - Getter
- (UIButton *)imageBtn {
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}

@end
