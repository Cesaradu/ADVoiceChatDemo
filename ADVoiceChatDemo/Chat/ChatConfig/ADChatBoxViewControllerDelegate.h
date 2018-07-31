//
//  ADChatBoxViewControllerDelegate.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>


@class ADMessage;
@class ADChatBoxViewController;
@class ADVideoView;

@protocol ADChatBoxViewControllerDelegate <NSObject>

// change chatBox height
- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController
        didChangeChatBoxHeight:(CGFloat)height;
/**
 *  send text message
 *
 *  @param chatboxViewController chatboxViewController
 *  @param messageStr            text
 */
- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController
               sendTextMessage:(NSString *)messageStr;
/**
 *  send image message
 *
 *  @param chatboxViewController ADChatBoxViewController
 *  @param image                 image
 *  @param imgPath               image path
 */
- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController
              sendImageMessage:(UIImage *)image
                     imagePath:(NSString *)imgPath;

/**
 *  send voice message
 *
 *  @param chatboxViewController ADChatBoxViewController
 *  @param voicePath             voice path
 */
- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController sendVoiceMessage:(NSString *)voicePath;

- (void)voiceDidStartRecording;
// voice太短
- (void)voiceRecordSoShort;

- (void)voiceWillDragout:(BOOL)inside;

- (void)voiceDidCancelRecording;


- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController
          didVideoViewAppeared:(ADVideoView *)videoView;


- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController sendVideoMessage:(NSString *)videoPath;

- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController sendFileMessage:(NSString *)fileName;


@end
