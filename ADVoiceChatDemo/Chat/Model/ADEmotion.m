//
//  ADEmotion.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADEmotion.h"

@implementation ADEmotion

- (BOOL)isEqual:(ADEmotion *)emotion {
    return [self.face_name isEqualToString:emotion.face_name] || [self.code isEqualToString:emotion.code];
}

@end
