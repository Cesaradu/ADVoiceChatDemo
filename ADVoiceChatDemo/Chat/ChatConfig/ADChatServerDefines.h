//
//  ADChatServerDefines.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#ifndef ADChatServerDefines_h
#define ADChatServerDefines_h

// 消息发送状态
typedef enum {
    ADMessageDeliveryState_Pending = 0,  // 待发送
    ADMessageDeliveryState_Delivering,   // 正在发送
    ADMessageDeliveryState_Delivered,    // 已发送，成功
    ADMessageDeliveryState_Failure,      // 发送失败
    ADMessageDeliveryState_ServiceFaid   // 发送服务器失败(可能其它错,待扩展)
} MessageDeliveryState;

// 消息类型
typedef enum {
    ADMessageType_Text  = 1,             // 文本
    ADMessageType_Voice,                 // 短录音
    ADMessageType_Image,                 // 图片
    ADMessageType_Video,                 // 短视频
    ADMessageType_Doc,                   // 文档
    ADMessageType_TextURL,               // 文本＋链接
    ADMessageType_ImageURL,              // 图片＋链接
    ADMessageType_URL,                   // 纯链接
    ADMessageType_DrtNews,               // 送达号
    ADMessageType_NTF   = 12,            // 通知
    ADMessageType_DTxt  = 21,            // 纯文本
    ADMessageType_DPic  = 22,            // 文本＋单图
    ADMessageType_DMPic = 23,            // 文本＋多图
    ADMessageType_DVideo= 24,            // 文本＋视频
    ADMessageType_PicURL= 25             // 动态图文链接
    
} ADMessageType;

typedef enum {
    ADGroup_SELF = 0,                    // 自己
    ADGroup_DOUBLE,                      // 双人组
    ADGroup_MULTI,                       // 多人组
    ADGroup_TODO,                        // 待办
    ADGroup_QING,                        // 轻应用
    ADGroup_NATIVE,                      // 原生应用
    ADGroup_DISCOVERY,                   // 发现
    ADGroup_DIRECT,                      // 送达号
    ADGroup_NOTIFY,                      // 通知
    ADGroup_BOOK                         // 通讯录
} ADGroupType;

// 消息状态
typedef enum {
    ADMessageStatus_unRead = 0,          // 消息未读
    ADMessageStatus_read,                // 消息已读
    ADMessageStatus_back                 // 消息撤回
} ADMessageStatus;

typedef enum {
    ADActionType_READ = 1,               // 语音已读
    ADActionType_BACK,                   // 消息撤回
    ADActionType_UPTO,                   // 消息读数
    ADActionType_KICK,                   // 请出会话
    ADActionType_OPOK,                   // 待办已办
    ADActionType_BDRT,                   // 送达号消息撤回
    ADActionType_GUPD,                   // 群信息修改
    ADActionType_UUPD,                   // 群成员信息修改
    ADActionType_DUPD,                   // 送达号信息修改
    ADActionType_OFFL = 10,              // 请您下线
    ADActionType_STOP = 11,              // 清除所有缓存
    ADActionType_UUPN                    // 改昵称
    
} ADActionType;

typedef NS_ENUM(NSInteger, ADChatBoxStatus) {
    ADChatBoxStatusNothing,     // 默认状态
    ADChatBoxStatusShowVoice,   // 录音状态
    ADChatBoxStatusShowFace,    // 输入表情状态
    ADChatBoxStatusShowMore,    // 显示“更多”页面状态
    ADChatBoxStatusShowKeyboard,// 正常键盘
    ADChatBoxStatusShowVideo    // 录制视频
};

typedef enum {
    ADDeliverSubStatus_Can        = 0,   // 可订阅
    ADDeliverSubStatus_Already,
    ADDeliverSubStatus_System
} ADDeliverSubStatus;

typedef enum {
    ADDeliverTopStatus_NO         = 0, // 非置顶
    ADDeliverTopStatus_YES             // 置顶
} ADDeliverTopStatus;


typedef enum {
    ADFileType_Other = 0,                // 其它类型
    ADFileType_Audio,                    //
    ADFileType_Video,                    //
    ADFileType_Html,
    ADFileType_Pdf,
    ADFileType_Doc,
    ADFileType_Xls,
    ADFileType_Ppt,
    ADFileType_Img,
    ADFileType_Txt
} ADFileType;


#endif /* ADChatServerDefines_h */

