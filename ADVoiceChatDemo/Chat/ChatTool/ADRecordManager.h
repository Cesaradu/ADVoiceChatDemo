//
//  ADRecordManager.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <AVFoundation/AVFoundation.h>

#define shortRecord @"shortRecord"

@protocol ADRecordManagerDelegate <NSObject>

// voice play finished
- (void)voiceDidPlayFinished;

@end

@interface ADRecordManager : NSObject <AVAudioRecorderDelegate, AVAudioPlayerDelegate>

@property (nonatomic, weak) id <ADRecordManagerDelegate>playDelegate;
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) AVAudioPlayer *player;

+ (id)shareManager;

// start recording
- (void)startRecordingWithFileName:(NSString *)fileName
                        completion:(void(^)(NSError *error))completion;
// stop recording
- (void)stopRecordingWithCompletion:(void(^)(NSString *recordPath))completion;

// 是否拥有权限
- (BOOL)canRecord;

// 取消当前录制
- (void)cancelCurrentRecording;

- (void)removeCurrentRecordFile:(NSString *)fileName;

/*********-------播放----------************/

- (void)startPlayRecorder:(NSString *)recorderPath;

- (void)stopPlayRecorder:(NSString *)recorderPath;

- (void)pause;


// 接收到的语音保存路径(文件以fileKey为名字)
- (NSString *)receiveVoicePathWithFileKey:(NSString *)fileKey;

// 获取语音时长
- (NSUInteger)durationWithAudio:(NSURL *)voiceUrl;

@end
