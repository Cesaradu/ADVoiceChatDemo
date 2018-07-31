//
//  ADChatBox.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ADChatBox;
@protocol ADChatBoxDelegate <NSObject>
/**
 *  输入框状态(位置)改变
 *
 *  @param chatBox    chatBox
 *  @param fromStatus 起始状态
 *  @param toStatus   目的状态
 */
- (void)chatBox:(ADChatBox *)chatBox changeStatusForm:(ADChatBoxStatus)fromStatus to:(ADChatBoxStatus)toStatus;

/**
 *  发送消息
 *
 *  @param chatBox     chatBox
 *  @param textMessage 消息
 */
- (void)chatBox:(ADChatBox *)chatBox sendTextMessage:(NSString *)textMessage;

/**
 *  输入框高度改变
 *
 *  @param chatBox chatBox
 *  @param height  height
 */
- (void)chatBox:(ADChatBox *)chatBox changeChatBoxHeight:(CGFloat)height;

/**
 *  开始录音
 *
 *  @param chatBox chatBox
 */
- (void)chatBoxDidStartRecordingVoice:(ADChatBox *)chatBox;
- (void)chatBoxDidStopRecordingVoice:(ADChatBox *)chatBox;
- (void)chatBoxDidCancelRecordingVoice:(ADChatBox *)chatBox;
- (void)chatBoxDidDrag:(BOOL)inside;


@end


@interface ADChatBox : UIView
/** 保存状态 */
@property (nonatomic, assign) ADChatBoxStatus status;

@property (nonatomic, weak) id <ADChatBoxDelegate> delegate;

/** 输入框 */
@property (nonatomic, strong) UITextView *textView;

@end
