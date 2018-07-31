//
//  ADFaceManager.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ADFaceManager : NSObject

+ (NSArray *)emojiEmotion;

+ (NSArray *)customEmotion;

+ (NSArray *)gifEmotion;

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight;

@end
