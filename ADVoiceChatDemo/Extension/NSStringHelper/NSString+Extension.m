//
//  NSString+Extension.m
//  BaseFramework
//
//  Created by hztuen on 17/3/20.
//  Copyright © 2017年 Cesar. All rights reserved.
//

#import "NSString+Extension.h"

#define EmojiCodeToSymbol(c) ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) | (c & 0x1C0000) << 18) | (c & 0x3F) << 24)

@implementation NSString (Extension)

+ (BOOL)isNULL:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@", string];
    if ([str isEqualToString:@""]) {
        return YES;
    }
    if ([str isKindOfClass:[NSNull class]]) {
        return YES;
    }
    if ([str isEqual:[NSNull null]]) {
        return YES;
    }
    if (str.length == 0) {
        return YES;
    }
    if (str == nil) {
        return YES;
    }
    if ([str isEqualToString:@"(null)"]) {
        return YES;
    }
    if ([str isEqualToString:@"<null>"]) {
        return YES;
    }
    if (str == NULL) {
        return YES;
    }
    return NO;
}

- (NSDictionary *)StringOfJsonConversionDictionary {
    
    if ([NSString isNULL:self]) {
        return nil;
    }
    
    NSData *jsonData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError *parseError;
    
    NSDictionary *Dictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&parseError];
    
    if(parseError) {
        
        return nil;
    }
    
    return Dictionary;
    
}

//时间戳转化时间格式字符串
+ (NSString *)timeStringChangeToTime:(double) timeString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeString/1000];
    NSString *string = [dateFormatter stringFromDate:date];
    return string;
}

//日期转换几分钟前、几小时前
+ (NSString *)compareCurrentTime:(NSString *)str {
    //把字符串转为NSdate
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *timeDate = [dateFormatter dateFromString:str];
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:timeDate];
    long temp = 0;
    NSString *result;
    if (timeInterval/60 < 1) {
        result = [NSString stringWithFormat:@"刚刚"];
    } else if((temp = timeInterval/60) < 60) {
        result = [NSString stringWithFormat:@"%ld分钟前",temp];
    } else if((temp = temp/60) < 24) {
        result = [NSString stringWithFormat:@"%ld小时前",temp];
    } else if((temp = temp/24) < 30) {
        if (temp == 1) {
            result = @"昨天";
        } else {
            result = [NSString stringWithFormat:@"%ld天前",temp];
        }
    } else if((temp = temp/30) < 12) {
        result = [NSString stringWithFormat:@"%ld月前",temp];
    } else {
        temp = temp/12;
        if (temp == 1) {
            result = @"去年";
        } else {
            result = [NSString stringWithFormat:@"%ld年前",temp];
        }
    }
    return  result;
}

+ (BOOL)isContainsEmoji:(NSString *)string {
    __block BOOL isEomji = NO;
    [string enumerateSubstringsInRange:NSMakeRange(0, [string length]) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop) {
        const unichar hs = [substring characterAtIndex:0];
        // surrogate pair
        if (0xd800 <= hs && hs <= 0xdbff) {
            if (substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
                if (0x1d000 <= uc && uc <= 0x1f77f) {
                    isEomji = YES;
                }
            }
        } else {
            // non surrogate
            if (0x2100 <= hs && hs <= 0x27ff && hs != 0x263b) {
                isEomji = YES;
            } else if (0x2B05 <= hs && hs <= 0x2b07) {
                isEomji = YES;
            } else if (0x2934 <= hs && hs <= 0x2935) {
                isEomji = YES;
            } else if (0x3297 <= hs && hs <= 0x3299) {
                isEomji = YES;
            } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 || hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50|| hs == 0x231a ) {
                isEomji = YES;
            }
            if (!isEomji && substring.length > 1) {
                const unichar ls = [substring characterAtIndex:1];
                if (ls == 0x20e3) {
                    isEomji = YES;
                }
            }
        }
    }];
    return isEomji;
}

+ (int)compareOneDay:(NSString *)firstDay withAnotherDay:(NSString *)secondDay {
    int ci;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSDate *dt1 = [[NSDate alloc] init];
    NSDate *dt2 = [[NSDate alloc] init];
    dt1 = [df dateFromString:firstDay];
    dt2 = [df dateFromString:secondDay];
    NSComparisonResult result = [dt1 compare:dt2];
    switch (result) {
        case NSOrderedAscending:
            ci = 1; // firstDay < secondDay
            break;
        case NSOrderedSame:
            ci = 0; // firstDay = secondDay
            break;
        case NSOrderedDescending:
            ci = - 1; // firstDay > secondDay
            break;
    }
    return ci;
}

- (NSString *)emoji {
    return [NSString emojiWithStringCode:self];
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode {
    char *charCode = (char *)stringCode.UTF8String;
    long intCode = strtol(charCode, NULL, 16);
    return [self emojiWithIntCode:(int)intCode];
}

+ (NSString *)emojiWithIntCode:(int)intCode {
    int symbol = EmojiCodeToSymbol(intCode);
    NSString *string = [[NSString alloc] initWithBytes:&symbol length:sizeof(symbol) encoding:NSUTF8StringEncoding];
    if (string == nil) { // 新版Emoji
        string = [NSString stringWithFormat:@"%C", (unichar)intCode];
    }
    return string;
}

- (CGSize)sizeWithMaxWidth:(CGFloat)width andFont:(UIFont *)font {
    CGSize maxSize = CGSizeMake(width, MAXFLOAT);
    NSDictionary *dict = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
}

- (NSString *)originName {
    NSArray *list = [self componentsSeparatedByString:@"_"];
    NSMutableString *orgName = [NSMutableString string];
    NSUInteger count = list.count;
    if (list.count > 1) {
        for (int i = 1; i < count; i ++) {
            [orgName appendString:list[i]];
            if (i < count-1) {
                [orgName appendString:@"_"];
            }
        }
    } else {  // 防越狱的情况下，本地改名字
        orgName = list[0];
    }
    return orgName;
}

+ (NSString *)currentName {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYYMMddHHMMss"];
    NSString *currentDate = [dateFormatter stringFromDate:[NSDate date]];
    return currentDate;
}

- (NSString *)firstStringSeparatedByString:(NSString *)separeted {
    NSArray *list = [self componentsSeparatedByString:separeted];
    return [list firstObject];
}

@end
