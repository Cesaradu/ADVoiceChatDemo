//
//  ADMessageHelper.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADMessageHelper.h"
#import "ADMessageModel.h"
#import "ADMessageFrame.h"
#import "ADMediaManager.h"
#import "ADRecordManager.h"
#import "ADVideoManager.h"
#import "ADFileTool.h"
#import "ADMessageConst.h"
#import "FMDBManager.h"

@implementation ADMessageHelper

// 创建一条本地消息
+ (ADMessageFrame *)createMessageFrame:(NSString *)type
                             messageId:(NSString *)messageId
                               content:(NSString *)content
                                  path:(NSString *)path
                              fromName:(NSString *)fromName
                         fromHeadImage:(NSString *)fromHeadImage
                               fileKey:(NSString *)fileKey
                              isSender:(BOOL)isSender
              receivedSenderByYourself:(BOOL)receivedSenderByYourself {
    ADMessage *message    = [[ADMessage alloc] init];
    message.fileKey       = fileKey;
    // 我默认了一个本机的当前时间，其实没用到，成功后都改成服务器时间了
    message.date          = [ADMessageHelper currentMessageTime];
    ADMessageModel *model = [[ADMessageModel alloc] init];
    type = [self cellTypeWithMessageType:type];
    message.type          = type;
    if ([type isEqualToString:TypeText]) {
        message.content = content;
    } else if ([type isEqualToString:TypePic]) {
        message.content = @"[图片]";
    } else if ([type isEqualToString:TypeVoice]) {
        message.content = @"[语音]";
    } else if ([type isEqualToString:TypeVideo]) {
        message.content = @"[视频]";
    } else if ([type isEqualToString:TypeFile]) {
        message.content = content;
    } else if ([type isEqualToString:TypeSystem]) {
        message.content = content;
    } else {
        message.content = content;
    }
    model.isSender        = isSender;
    model.mediaPath       = path;
    model.name = fromName;
    model.headImage = fromHeadImage;
    model.message_id = messageId;
    if (isSender) {
        message.deliveryState = ADMessageDeliveryState_Delivering;
    } else {
        message.deliveryState = ADMessageDeliveryState_Delivered;
    }
    if (receivedSenderByYourself) { // 接收到得信息是自己发的
        message.deliveryState = ADMessageDeliveryState_Delivered;
        model.isSender        = YES;
    }
    model.message = message;
    ADMessageFrame *modelF = [[ADMessageFrame alloc] init];
    modelF.model = model;
    
    //存入数据库
    [[FMDBManager sharedFMDBManager] addMessage:model];
    
    return modelF;
}


+ (ADMessageFrame *)createMessageMeReceiverFrame:(NSString *)type
                                         content:(NSString *)content
                                            path:(NSString *)path
                                            from:(NSString *)from
                                         fileKey:(NSString *)fileKey {
    ADMessage *message = [[ADMessage alloc] init];
    message.type       = type;
    ADMessageModel *model = [[ADMessageModel alloc] init];
    message.fileKey    = fileKey;
    model.isSender = NO;
    message.content    = content;
    model.mediaPath    = path;
    message.deliveryState = ADMessageDeliveryState_Delivered;
    model.message = message;
    ADMessageFrame *modelF = [[ADMessageFrame alloc] init];
    modelF.model = model;
    return modelF;
}

+ (ADMessageFrame *)createTimeMessageFrame:(NSString *)type
                                   content:(NSString *)content
                                      path:(NSString *)path
                                      from:(NSString *)from
                                        to:(NSString *)to
                                   fileKey:(NSString *)fileKey
                                  isSender:(BOOL)isSender
                  receivedSenderByYourself:(BOOL)receivedSenderByYourself {
    ADMessage *message    = [[ADMessage alloc] init];
    message.to            = to;
    message.from          = from;
    message.fileKey       = fileKey;
    // 我默认了一个本机的当前时间，其实没用到，成功后都改成服务器时间了
    message.date          = [ADMessageHelper currentMessageTime];
    ADMessageModel *model = [[ADMessageModel alloc] init];
    type = [self cellTypeWithMessageType:type];
    message.type          = type;
    if ([type isEqualToString:TypeText]) {
        message.content = content;
    } else if ([type isEqualToString:TypePic]) {
        message.content = @"[图片]";
    } else if ([type isEqualToString:TypeVoice]) {
        message.content = @"[语音]";
    } else if ([type isEqualToString:TypeVideo]) {
        message.content = @"[视频]";
    } else if ([type isEqualToString:TypeFile]) {
        message.content = @"[文件]";
    } else if ([type isEqualToString:TypeSystem]) {
        message.content = content;
    }
    model.isSender        = isSender;
    model.mediaPath       = path;
    if (isSender) {
        message.deliveryState = ADMessageDeliveryState_Delivering;
    } else {
        message.deliveryState = ADMessageDeliveryState_Delivered;
    }
    if (receivedSenderByYourself) { // 接收到得信息是自己发的
        message.deliveryState = ADMessageDeliveryState_Delivered;
        model.isSender        = YES;
    }
    model.message = message;
    ADMessageFrame *modelF = [[ADMessageFrame alloc] init];
    modelF.model = model;
    return modelF;
}


/**
 *  创建一条发送消息
 *
 *  @param type    消息类型
 *  @param content 消息文本内容，其它类型的类型名称:[图片]
 *  @param fileKey 音频文件的fileKey
 *  @param from    发送者
 *  @param to      接收者
 *  @param lnk     连接地址URL,图片格式,文件名称 （目前没用到）
 *  @param status  消息状态 （目前没用到）
 *
 *  @return 发送的消息
 */
+ (ADMessage *)createSendMessage:(NSString *)type
                         content:(NSString *)content
                         fileKey:(NSString *)fileKey
                            from:(NSString *)from
                              to:(NSString *)to
                             lnk:(NSString *)lnk
                          status:(NSString *)status {
    ADMessage *message    = [[ADMessage alloc] init];
    message.from          = from;
    message.to            = to;
    message.content       = content;
    message.fileKey       = fileKey;
    message.lnk           = lnk;
    if ([type isEqualToString:TypeText]) {
        message.type      = @"1";
    } else if ([type isEqualToString:TypePic]) {
        message.type      = @"3";
    } else if ([type isEqualToString:TypeVoice]) {
        message.type      = @"2";
    } else if ([type isEqualToString:TypeVideo]) {
        message.type      = @"4";
    } else if ([type isEqualToString:TypeFile]) {
        message.type      = @"5";
    }else if ([type isEqualToString:TypePicText]) {
        message.type      = @"7";
    }
    //    message.localMsgId    = [self localMessageId:content];
    message.date          = [ADMessageHelper currentMessageTime];
    return message;
}


// 获取语音消息时长
+ (CGFloat)getVoiceTimeLengthWithPath:(NSString *)path {
    AVURLAsset* audioAsset =[AVURLAsset URLAssetWithURL:[NSURL fileURLWithPath:path] options:nil];
    CMTime audioDuration = audioAsset.duration;
    CGFloat audioDurationSeconds =CMTimeGetSeconds(audioDuration);
    return audioDurationSeconds;
}

// 图片按钮在窗口中得位置
+ (CGRect)photoFramInWindow:(UIButton *)photoView {
    return [photoView convertRect:photoView.bounds toView:[UIApplication sharedApplication].keyWindow];
}

// 放大后的图片按钮在窗口中的位置
+ (CGRect)photoLargerInWindow:(UIButton *)photoView {
    //    CGSize imgSize     = photoView.imageView.image.size;
    CGSize  imgSize    = photoView.currentBackgroundImage.size;
    CGFloat appWidth   = [UIScreen mainScreen].bounds.size.width;
    CGFloat appHeight  = [UIScreen mainScreen].bounds.size.height;
    CGFloat height     = imgSize.height / imgSize.width * appWidth;
    CGFloat photoY     = 0;
    if (height < appHeight) {
        photoY         = (appHeight - height) * 0.5;
    }
    return CGRectMake(0, photoY, appWidth, height);
}

// 根据消息类型得到cell的标识
+ (NSString *)cellTypeWithMessageType:(NSString *)type {
    if ([type isEqualToString:@"1"]) {
        return TypeText;
    } else if ([type isEqualToString:@"2"]) {
        return TypeVoice;
    } else if ([type isEqualToString:@"3"]) {
        return TypePic;
    } else if ([type isEqualToString:@"4"]) {
        return TypeVideo;
    } else if ([type isEqualToString:@"5"]) {
        return TypeFile;
    } else {
        return type;
    }
}

// 删除消息附件
+ (void)deleteMessage:(ADMessageModel *)messageModel {
    if ([ADFileTool fileExistsAtPath:messageModel.mediaPath]) {
        [ADFileTool removeFileAtPath:messageModel.mediaPath];
    }
}

// current message time
+ (NSInteger)currentMessageTime {
    NSTimeInterval time = [[NSDate date] timeIntervalSince1970];
    NSInteger iTime     = (NSInteger)(time * 1000);
    return iTime;
}

// time format
+ (NSString *)timeFormatWithDate:(NSInteger)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSString *date = [formatter stringFromDate:currentDate];
    return date;
}


+ (NSString *)timeFormatWithDate2:(NSInteger)time {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yy/MM/dd HH:mm"];
    NSDate * currentDate = [NSDate dateWithTimeIntervalSince1970:time/1000];
    NSString *date = [formatter stringFromDate:currentDate];
    return date;
    
}

+ (NSDictionary *)fileTypeDictionary {
    NSDictionary *dic = @{
                          @"mp3":@1,@"mp4":@2,@"mpe":@2,@"docx":@5,
                          @"amr":@1,@"avi":@2,@"wmv":@2,@"xls":@6,
                          @"wav":@1,@"rmvb":@2,@"mkv":@2,@"xlsx":@6,
                          @"mp3":@1,@"rm":@2,@"vob":@2,@"ppt":@7,
                          @"aac":@1,@"asf":@2,@"html":@3,@"pptx":@7,
                          @"wma":@1,@"divx":@2,@"htm":@3,@"png":@8,
                          @"ogg":@1,@"mpg":@2,@"pdf":@4,@"jpg":@8,
                          @"ape":@1,@"mpeg":@2,@"doc":@5,@"jpeg":@8,
                          @"gif":@8,@"bmp":@8,@"tiff":@8,@"svg":@8
                          };
    return dic;
}

+ (NSNumber *)fileType:(NSString *)type {
    NSDictionary *dic = [self fileTypeDictionary];
    return [dic objectForKey:type];
}

+ (UIImage *)allocationImage:(ADFileType)type {
    switch (type) {
        case ADFileType_Audio:
            return [UIImage imageNamed:@"yinpin"];
            break;
        case ADFileType_Video:
            return [UIImage imageNamed:@"shipin"];
            break;
        case ADFileType_Html:
            return [UIImage imageNamed:@"html"];
            break;
        case ADFileType_Pdf:
            return  [UIImage imageNamed:@"pdf"];
            break;
        case ADFileType_Doc:
            return  [UIImage imageNamed:@"word"];
            break;
        case ADFileType_Xls:
            return [UIImage imageNamed:@"excerl"];
            break;
        case ADFileType_Ppt:
            return [UIImage imageNamed:@"ppt"];
            break;
        case ADFileType_Img:
            return [UIImage imageNamed:@"zhaopian"];
            break;
        case ADFileType_Txt:
            return [UIImage imageNamed:@"txt"];
            break;
        default:
            return [UIImage imageNamed:@"iconfont-wenjian"];
            break;
    }
}

+ (NSString *)timeDurationFormatter:(NSUInteger)duration {
    float M = duration/60.0;
    float S = duration - (int)M * 60;
    NSString *timeFormatter = [NSString stringWithFormat:@"%02.0lf:%02.0lf",M,S];
    return  timeFormatter;
}

@end
