//
//  ADFaceManager.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADFaceManager.h"
#import "ADEmotion.h"

@implementation ADFaceManager

static NSArray * _emojiEmotions,*_custumEmotions,*gifEmotions;

+ (NSArray *)emojiEmotion {
    if (_emojiEmotions) {
        return _emojiEmotions;
    }
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"emoji.plist" ofType:nil];
    _emojiEmotions  = [ADEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    return _emojiEmotions;
}

+ (NSArray *)customEmotion {
    if (_custumEmotions) {
        return _custumEmotions;
    }
    NSString *path  = [[NSBundle mainBundle] pathForResource:@"normal_face.plist" ofType:nil];
    _custumEmotions = [ADEmotion mj_objectArrayWithKeyValuesArray:[NSArray arrayWithContentsOfFile:path]];
    return _custumEmotions;
}

+ (NSArray *)gifEmotion {
    return nil;
}

+ (NSMutableAttributedString *)transferMessageString:(NSString *)message
                                                font:(UIFont *)font
                                          lineHeight:(CGFloat)lineHeight {
    NSMutableAttributedString *attributeStr
    = [[NSMutableAttributedString alloc] initWithString:message];
    NSString *regEmj  = @"\\[[a-zA-Z0-9\\/\\u4e00-\\u9fa5]+\\]";// [微笑]、［哭］等自定义表情处理
    NSError *error    = nil;
    NSRegularExpression *expression = [NSRegularExpression regularExpressionWithPattern:regEmj options:NSRegularExpressionCaseInsensitive error:&error];
    if (!expression) {
        NSLog(@"%@",error);
        return attributeStr;
    }
    [attributeStr addAttribute:NSFontAttributeName value:font range:NSMakeRange(0, attributeStr.length)];
    NSArray *resultArray = [expression matchesInString:message options:0 range:NSMakeRange(0, message.length)];
    NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:resultArray.count];
    for (NSTextCheckingResult *match in resultArray) {
        NSRange range    = match.range;
        NSString *subStr = [message substringWithRange:range];
        NSArray *faceArr = [ADFaceManager customEmotion];
        for (ADEmotion *face in faceArr) {
            if ([face.face_name isEqualToString:subStr]) {
                NSTextAttachment *attach   = [[NSTextAttachment alloc] init];
                attach.image               = [UIImage imageNamed:face.face_name];
                // 位置调整Y值就行
                attach.bounds              = CGRectMake(0, -4, lineHeight, lineHeight);
                NSAttributedString *imgStr = [NSAttributedString attributedStringWithAttachment:attach];
                NSMutableDictionary *imagDic   = [NSMutableDictionary dictionaryWithCapacity:2];
                [imagDic setObject:imgStr forKey:@"image"];
                [imagDic setObject:[NSValue valueWithRange:range] forKey:@"range"];
                [mutableArray addObject:imagDic];
            }
        }
    }
    for (int i =(int) mutableArray.count - 1; i >= 0; i --) {
        NSRange range;
        [mutableArray[i][@"range"] getValue:&range];
        [attributeStr replaceCharactersInRange:range withAttributedString:mutableArray[i][@"image"]];
    }
    return attributeStr;
}

@end
