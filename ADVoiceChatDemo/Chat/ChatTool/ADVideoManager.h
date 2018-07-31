//
//  ADVideoManager.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^RecordingFinished)(NSString *path);

@interface ADVideoManager : NSObject

+ (instancetype)shareManager;

- (void)setVideoPreviewLayer:(UIView *)videoLayerView;

- (void)startRecordingVideoWithFileName:(NSString *)videoName;

// 录制权限
- (BOOL)canRecordViedo;

// stop recording
- (void)stopRecordingVideo:(RecordingFinished)finished;

- (void)cancelRecordingVideoWithFileName:(NSString *)videoName;

// 退出
- (void)exit;

// 接收到的视频保存路径(文件以fileKey为名字)
- (NSString *)receiveVideoPathWithFileKey:(NSString *)fileKey;

- (NSString *)videoPathWithFileName:(NSString *)videoName;

- (NSString *)videoPathForMP4:(NSString *)namePath;
// 自定义路径
- (NSString *)videoPathWithFileName:(NSString *)videoName fileDir:(NSString *)fileDir;

@end
