//
//  ADChatServerDefines.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

/************Event*************/
extern NSString *const ADRouterEventVoiceTapEventName;
extern NSString *const ADRouterEventImageTapEventName;
extern NSString *const ADRouterEventTextUrlTapEventName;
extern NSString *const ADRouterEventMenuTapEventName;
extern NSString *const ADRouterEventVideoTapEventName;
extern NSString *const ADRouterEventShareTapEvent;
extern NSString *const ADRouterEventVideoRecordExit;
extern NSString *const ADRouterEventVideoRecordCancel;
extern NSString *const ADRouterEventVideoRecordFinish;
extern NSString *const ADRouterEventVideoRecordStart;
extern NSString *const ADRouterEventURLSkip;
extern NSString *const ADRouterEventScanFile;

/************Name*************/
extern NSString *const MessageKey;
extern NSString *const VoiceIcon;
extern NSString *const RedView;
// 消息类型
extern NSString *const TypeSystem;
extern NSString *const TypeText;
extern NSString *const TypeVoice;
extern NSString *const TypePic;
extern NSString *const TypeVideo;
extern NSString *const TypeFile;
extern NSString *const TypePicText;

/** 消息类型的KEY */
extern NSString *const MessageTypeKey;
extern NSString *const VideoPathKey;

extern NSString *const ADSelectEmotionKey;

/************Notification*************/
extern NSString *const ADEmotionDidSelectNotification;
extern NSString *const ADEmotionDidDeleteNotification;
extern NSString *const ADEmotionDidSendNotification;
//extern NSString *const NotificationReceiveUnreadMessage;
extern NSString *const NotificationDidCreatedConversation;
extern NSString *const NotificationFirstMessage;
extern NSString *const NotificationDidUpdateDeliver;
extern NSString *const NotificationPushDidReceived;
extern NSString *const NotificationDeliverChanged;
extern NSString *const NotificationBackMsgNotification;
extern NSString *const NotificationGPhotoDidChanged;
extern NSString *const NotificationReloadDataIMSource;
extern NSString *const NotificationUserHeadImgChangedNotification;
extern NSString *const NotificationKickUserNotification;
extern NSString *const NotificationShareExitNotification;
// 取消分享
extern NSString *const ADShareCancelNotification ;
// 确认分享
extern NSString *const ADShareConfirmNotification;
extern NSString *const ADShareStayInAppNotification;
extern NSString *const ADShareBackOtherAppNotification;


