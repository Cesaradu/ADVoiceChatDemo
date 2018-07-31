//
//  NSString+Extension.h
//  BaseFramework
//
//  Created by hztuen on 17/3/20.
//  Copyright © 2017年 Cesar. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Extension)

//判断字符串是否为空
+ (BOOL)isNULL:(NSString *)string;

/*
 把JSON格式的字符串转换成字典
 */
- (NSDictionary *)StringOfJsonConversionDictionary;

//时间戳转化时间格式字符串
+ (NSString *)timeStringChangeToTime:(double) timeString;

//日期转换几分钟前、几小时前
+ (NSString *)compareCurrentTime:(NSString *)str;

//判断是否包含表情符号
+ (BOOL)isContainsEmoji:(NSString *)string;

//判断两个日期大小
+ (int)compareOneDay:(NSString *)firstDay withAnotherDay:(NSString *)secondDay;

- (NSString *)emoji;

- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font;

- (NSString *)originName;

+ (NSString *)currentName;

- (NSString *)firstStringSeparatedByString:(NSString *)separeted;

@end
