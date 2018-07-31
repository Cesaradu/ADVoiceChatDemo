//
//  ADMediaManager.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADMessageFrame.h"
#import "ADMessageModel.h"

#define kArrowMe @"Chat/ArrowMe"
#define kMyPic @"Chat/MyPic"
#define kVideoPic @"Chat/VideoPic"
#define kVideoImageType @"png"
#define kDeliver @"Deliver"

@interface ADMediaManager : NSObject

+ (instancetype)sharedManager;

/**
 *  get image from local path
 *
 *  @param localPath 路径
 *
 *  @return 图片
 */
- (UIImage *)imageWithLocalPath:(NSString *)localPath;

- (void)clearReuseImageMessage:(ADMessageModel *)message;

// me to you
- (UIImage *)arrowMeImage:(UIImage *)image
                     size:(CGSize)imageSize
                mediaPath:(NSString *)mediaPath
                 isSender:(BOOL)isSender;

- (void)saveArrowMeImage:(UIImage *)image
           withMediaPath:(NSString *)mediPath;

/**
 *  创建图片的保存路径
 *
 *  @param mainFolder  主地址
 *  @param childFolder 子地址
 *
 *  @return 地址
 */
- (NSString *)createFolderPahtWithMainFolder:(NSString *)mainFolder
                                 childFolder:(NSString *)childFolder;

/**
 *  保存图片到沙盒
 *
 *  @param image 图片
 *
 *  @return 图片路径
 */
- (NSString *)saveImage:(UIImage *)image;

- (void)clearCaches;

// 发送图片的地址
- (NSString *)sendImagePath:(NSString *)imgName;

/// video first cover image
- (UIImage *)videoConverPhotoWithVideoPath:(NSString *)videoPath
                                      size:(CGSize)imageSize
                                  isSender:(BOOL)isSender;

// 保存接收到图片 small-fileKey.png
- (NSString *)receiveImagePathWithFileKey:(NSString *)fileKey
                                     type:(NSString *)type;

// 小图路径
- (NSString *)smallImgPath:(NSString *)fileKey;

// 原图路径
- (NSString *)originImgPath:(ADMessageFrame *)messageF;

// get image with imgName
- (NSString *)imagePathWithName:(NSString *)imageName;

// get videoImage from sandbox
- (UIImage *)videoImageWithFileName:(NSString *)fileName;

// 送达号
- (NSString *)delieveImagePath:(NSString *)fileKey;
- (NSString *)deliverFilePath:(NSString *)name
                         type:(NSString *)type;

- (NSString *)videoImagePath:(NSString *)fileName;

@end
