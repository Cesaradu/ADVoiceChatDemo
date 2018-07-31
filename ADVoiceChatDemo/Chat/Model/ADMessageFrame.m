//
//  ADMessageFrame.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADMessageFrame.h"
#import "ADMessageModel.h"
#import "ADMediaManager.h"
#import "ADMessageConst.h"
#import "ADMessageHelper.h"
#import "ADVideoManager.h"

@implementation ADMessageFrame

- (void)setModel:(ADMessageModel *)model {
    _model = model;
    
    CGFloat headToView    = 10;
    CGFloat headToBubble  = 3;
    CGFloat headWidth     = 45;
    CGFloat cellMargin    = 10;
    CGFloat bubblePadding = 10;
    CGFloat chatLabelMax  = ScreenWidth - headWidth - 100;
    CGFloat arrowWidth    = 0;      // 气泡箭头
    CGFloat topViewH      = 10;
    CGFloat cellMinW      = 60;     // cell的最小宽度值,针对文本
    
    CGSize timeSize  = CGSizeMake(0, 0);
    if (model.isSender) {
        cellMinW = timeSize.width + arrowWidth + bubblePadding*2;
        CGFloat headX = ScreenWidth - headToView - headWidth;
        _headImageViewF = CGRectMake(headX, cellMargin, headWidth, headWidth);
        _nameLabelF = CGRectMake(CGRectGetMinX(_headImageViewF) - headToBubble - chatLabelMax, cellMargin, chatLabelMax, 15);
        if ([model.message.type isEqualToString:TypeText]) { // 文字
            CGSize chateLabelSize = [model.message.content sizeWithMaxWidth:chatLabelMax andFont:MessageFont];
            CGSize bubbleSize     = CGSizeMake(chateLabelSize.width + bubblePadding * 2 + arrowWidth, chateLabelSize.height + bubblePadding * 2);
            CGSize topViewSize    = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
            _bubbleViewF          = CGRectMake(CGRectGetMinX(_headImageViewF) - headToBubble - bubbleSize.width, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGFloat x             = CGRectGetMinX(_bubbleViewF) + bubblePadding - 3;
            _topViewF             = CGRectMake(CGRectGetMinX(_headImageViewF) - headToBubble - topViewSize.width-headToBubble-5, cellMargin,topViewSize.width,topViewSize.height);
            _chatLabelF           = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5 + bubblePadding, chateLabelSize.width, chateLabelSize.height);
        } else if ([model.message.type isEqualToString:TypePic]) { // 图片
            CGSize imageSize = CGSizeMake(40, 40);
            UIImage *image   = [UIImage imageWithContentsOfFile:[[ADMediaManager sharedManager] imagePathWithName:model.mediaPath.lastPathComponent]];
            if (image) {
                imageSize          = [self handleImage:image.size];
            }
            imageSize.width        = imageSize.width > timeSize.width ? imageSize.width : timeSize.width;
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGSize bubbleSize      = CGSizeMake(imageSize.width, imageSize.height);
            CGFloat bubbleX        = CGRectGetMinX(_headImageViewF)-headToBubble-bubbleSize.width;
            _bubbleViewF           = CGRectMake(bubbleX, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF             = CGRectMake(x, cellMargin,topViewSize.width,topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, imageSize.width, imageSize.height);
        } else if ([model.message.type isEqualToString:TypeVoice]) { // 语音消息
            CGFloat bubbleViewW     = 100; //暂时写死，后期可根据语音时长处理长度
            _bubbleViewF = CGRectMake(CGRectGetMinX(_headImageViewF) - headToBubble - bubbleViewW, CGRectGetMaxY(_nameLabelF) + 5, bubbleViewW, 40);
            _topViewF               = CGRectMake(CGRectGetMinX(_bubbleViewF), cellMargin, bubbleViewW - arrowWidth, topViewH);
            // 假设
            NSString *duraStr = @"1000";
            CGSize durSize = [duraStr sizeWithMaxWidth:chatLabelMax andFont:[UIFont systemFontOfSize:14]];
            _durationLabelF         = CGRectMake(CGRectGetMinX(_bubbleViewF)+ bubblePadding , CGRectGetMaxY(_nameLabelF) + 15, durSize.width, 20);
            _voiceIconF = CGRectMake(CGRectGetMaxX(_bubbleViewF) - 22, CGRectGetMaxY(_nameLabelF) + 15, 11, 16.5);// - 20
        }  else if ([model.message.type isEqualToString:TypeVideo]) { // 视频信息
            CGSize imageSize       = CGSizeMake(150, 150);
            UIImage *videoImage = [[ADMediaManager sharedManager] videoImageWithFileName:model.mediaPath.lastPathComponent];
            if (!videoImage) {
                NSString *path          = [[ADVideoManager shareManager] receiveVideoPathWithFileKey:[model.mediaPath.lastPathComponent stringByDeletingPathExtension]];
                videoImage    = [UIImage videoFramerateWithPath:path];
            }
            if (videoImage) {
                float scale        = videoImage.size.height/videoImage.size.width;
                imageSize = CGSizeMake(150, 140*scale);
            }
            CGSize bubbleSize = CGSizeMake(imageSize.width, imageSize.height);
            _bubbleViewF = CGRectMake(CGRectGetMinX(_headImageViewF)-headToBubble-bubbleSize.width, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x, cellMargin, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, imageSize.width, imageSize.height);
        } else if ([model.message.type isEqualToString:TypeFile]) {
            CGSize bubbleSize = CGSizeMake(253, 95.0);
            _bubbleViewF = CGRectMake(CGRectGetMinX(_headImageViewF)-headToBubble-bubbleSize.width, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(bubbleSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x, cellMargin, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
        } else if ([model.message.type isEqualToString:TypePicText]) {
            CGSize bubbleSize = CGSizeMake(253, 120.0);
            _bubbleViewF = CGRectMake(CGRectGetMinX(_headImageViewF)-headToBubble-bubbleSize.width, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(bubbleSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x, cellMargin, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
        }
        CGFloat activityX = _bubbleViewF.origin.x-40;
        CGFloat activityY = (_bubbleViewF.origin.y + _bubbleViewF.size.height)/2 - 5;
        CGFloat activityW = 40;
        CGFloat activityH = 40;
        _activityF        = CGRectMake(activityX, activityY, activityW, activityH);
        _retryButtonF     = _activityF;
    } else {    // 接收者
        _headImageViewF   = CGRectMake(headToView, cellMargin, headWidth, headWidth);
        _nameLabelF = CGRectMake(CGRectGetMaxX(_headImageViewF) + headToBubble, cellMargin, chatLabelMax, 15);
        CGSize nameSize       = CGSizeMake(0, 0);
        cellMinW = nameSize.width + 6 + timeSize.width; // 最小宽度
        if ([model.message.type isEqualToString:TypeText]) {
            CGSize chateLabelSize = [model.message.content sizeWithMaxWidth:chatLabelMax andFont:MessageFont];
            CGSize topViewSize    = CGSizeMake(cellMinW+bubblePadding*2, topViewH);
            CGSize bubbleSize = CGSizeMake(chateLabelSize.width + bubblePadding * 2 + arrowWidth, chateLabelSize.height + bubblePadding * 2);
            
            _bubbleViewF  = CGRectMake(CGRectGetMaxX(_headImageViewF) + headToBubble, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGFloat x     = CGRectGetMinX(_bubbleViewF) + bubblePadding + arrowWidth + 3;
            _topViewF     = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth, cellMargin, topViewSize.width, topViewSize.height);
            _chatLabelF   = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5 + bubblePadding, chateLabelSize.width, chateLabelSize.height);
        } else if ([model.message.type isEqualToString:TypePic]) {
            CGSize imageSize = CGSizeMake(40, 40);
            UIImage *image   = [UIImage imageWithContentsOfFile:[[ADMediaManager sharedManager] imagePathWithName:model.mediaPath.lastPathComponent]];
            if (image) {
                imageSize = [self handleImage:image.size];
            }
            imageSize.width        = imageSize.width > cellMinW ? imageSize.width : cellMinW;
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGSize bubbleSize      = CGSizeMake(imageSize.width, imageSize.height);
            CGFloat bubbleX        = CGRectGetMaxX(_headImageViewF)+headToBubble;
            _bubbleViewF           = CGRectMake(bubbleX, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x+arrowWidth, cellMargin, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, imageSize.width, imageSize.height);
            
        } else if ([model.message.type isEqualToString:TypeVoice]) {   // 语音
            CGFloat bubbleViewW = 100; //
            CGFloat voiceToBull = 10;
            
            _bubbleViewF = CGRectMake(CGRectGetMaxX(_headImageViewF) + headToBubble, CGRectGetMaxY(_nameLabelF) + 5, bubbleViewW, 40);
            _topViewF    = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth, cellMargin, bubbleViewW-arrowWidth, topViewH);
            _voiceIconF = CGRectMake(CGRectGetMinX(_bubbleViewF)+arrowWidth+bubblePadding, CGRectGetMaxY(_nameLabelF) + 15, 11, 16.5);
            // 假设
            NSString *duraStr = @"1000";
            CGSize durSize = [duraStr sizeWithMaxWidth:chatLabelMax andFont:[UIFont systemFontOfSize:14]];
            _durationLabelF = CGRectMake(CGRectGetMaxX(_bubbleViewF) - voiceToBull - durSize.width, CGRectGetMaxY(_nameLabelF) + 15, durSize.width, durSize.height);
            _redViewF = CGRectMake(CGRectGetMaxX(_bubbleViewF) + 6, CGRectGetMinY(_bubbleViewF) + _bubbleViewF.size.height*0.5-4, 8, 8);
        } else if ([model.message.type isEqualToString:TypeVideo]) {   // 视频
            CGSize imageSize       = CGSizeMake(150, 150);
            UIImage *videoImage = [[ADMediaManager sharedManager] videoImageWithFileName:[NSString stringWithFormat:@"%@.png",model.message.fileKey]];
            if (!videoImage) {
                NSString *path          = [[ADVideoManager shareManager] receiveVideoPathWithFileKey:model.message.fileKey];
                videoImage    = [UIImage videoFramerateWithPath:path];
            }
            if (videoImage) {
                float scale        = videoImage.size.height/videoImage.size.width;
                imageSize = CGSizeMake(150, 140*scale);
            }
            CGSize bubbleSize = CGSizeMake(imageSize.width, imageSize.height+topViewH);
            _bubbleViewF = CGRectMake(CGRectGetMaxX(_headImageViewF)+headToBubble, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(imageSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x+arrowWidth, cellMargin, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, imageSize.width, imageSize.height);
        } else if ([model.message.type isEqualToString:TypeSystem]) {
            CGSize size           = [model.message.content sizeWithMaxWidth:ScreenWidth-40 andFont:[UIFont systemFontOfSize:11.0]];
            _bubbleViewF = CGRectMake(0, 0, 0, size.height+10);// 只需要高度就行
        } else if ([model.message.type isEqualToString:TypeFile]) {
            CGSize bubbleSize = CGSizeMake(253, 95.0);
            _bubbleViewF = CGRectMake(CGRectGetMaxX(_headImageViewF)+headToBubble, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(bubbleSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x+arrowWidth, cellMargin, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
        } else if ([model.message.type isEqualToString:TypePicText]) {
            CGSize bubbleSize = CGSizeMake(253, 120.0);
            _bubbleViewF = CGRectMake(CGRectGetMaxX(_headImageViewF)+headToBubble, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
            CGSize topViewSize     = CGSizeMake(bubbleSize.width-arrowWidth, topViewH);
            CGFloat x              = CGRectGetMinX(_bubbleViewF);
            _topViewF              = CGRectMake(x+arrowWidth, cellMargin, topViewSize.width, topViewSize.height);
            _picViewF              = CGRectMake(x, CGRectGetMaxY(_nameLabelF) + 5, bubbleSize.width, bubbleSize.height);
        }
        
    }
    _cellHight = MAX(CGRectGetMaxY(_bubbleViewF), CGRectGetMaxY(_headImageViewF)) + cellMargin;
    if ([model.message.type isEqualToString:TypeSystem]) {
        CGSize size           = [model.message.content sizeWithMaxWidth:[UIScreen mainScreen].bounds.size.width-40 andFont:[UIFont systemFontOfSize:11.0]];
        _cellHight = size.height+10;
    }
}

// 缩放，临时的方法
- (CGSize)handleImage:(CGSize)retSize {
    CGFloat scaleH = 0.22;
    CGFloat scaleW = 0.38;
    CGFloat height = 0;
    CGFloat width = 0;
    if (retSize.height / ScreenHeight + 0.16 > retSize.width / ScreenWidth) {
        height = ScreenHeight * scaleH;
        width = retSize.width / retSize.height * height;
    } else {
        width = ScreenWidth * scaleW;
        height = retSize.height / retSize.width * width;
    }
    return CGSizeMake(width, height);
}

@end

