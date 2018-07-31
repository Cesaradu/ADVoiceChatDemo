//
//  Define.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/10.
//  Copyright © 2018年 Adu. All rights reserved.
//

#ifndef Define_h
#define Define_h

// 在release版本中关闭NSLog打印
#ifdef DEBUG
#define NSLog(format, ...) printf("class: <%p %s:(%d) > method: %s \n%s\n", self, [[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, __PRETTY_FUNCTION__, [[NSString stringWithFormat:(format), ##__VA_ARGS__] UTF8String] )
#else
#define NSLog(format, ...)
#endif

//屏幕宽高
#define ScreenHeight    [[UIScreen mainScreen] bounds].size.height
#define ScreenWidth     [[UIScreen mainScreen] bounds].size.width
#define Width           self.view.frame.size.width
#define Height          self.view.frame.size.height

/**
 适配 给定4.7寸屏尺寸，适配4和5.5寸屏尺寸
 根据屏幕宽的比例
 5，se: 320, 4寸屏
 6,7,8,X: 375, 4.7寸屏
 plus: 414, 5.5寸屏
 */
#define Suit55Inch           1.104
#define Suit4Inch            1.171875

// 系统判定
#define IOS_VERSION    [[[UIDevice currentDevice] systemVersion] floatValue]
#define IS_IOS8        (IOS_VERSION>=8.0 && IOS_VERSION<9.0)
#define Is_IOS9        (IOS_VERSION>=9.0 && IOS_VERSION<10.0)
#define Is_IOS10       (IOS_VERSION>=10.0 && IOS_VERSION<11.0)
#define Is_IOS11       (IOS_VERSION>=11.0)

// 屏幕判定
#define IS_IPHONE35INCH  ([SDVersion deviceSize] == Screen3Dot5inch ? YES : NO)//4, 4S
#define IS_IPHONE4INCH  ([SDVersion deviceSize] == Screen4inch ? YES : NO)//5, 5C, 5S, SE
#define IS_IPHONE47INCH  ([SDVersion deviceSize] == Screen4Dot7inch ? YES : NO)//6, 6S, 7，8
#define IS_IPHONE55INCH ([SDVersion deviceSize] == Screen5Dot5inch ? YES : NO)//6P, 6SP, 7P，7SP，8P
#define IS_IPHONE58INCH ([SDVersion deviceSize] == Screen5Dot8inch ? YES : NO)//iPhonex

// Set UserDefaults
#define DefaultsSet(value, key) [[NSUserDefaults standardUserDefaults] setObject:value forKey:key]
// Get UserDefaultValue
#define ValueGet(key)  [[NSUserDefaults standardUserDefaults] objectForKey:key] ? [[NSUserDefaults standardUserDefaults] objectForKey:key] : @""

// keychain
#define  KEY_USERNAME_PASSWORD @"com.cesar.ADVoiceChatDemo.usernamepassword"
#define  KEY_USERNAME @"com.cesar.ADVoiceChatDemo.username"
#define  KEY_PASSWORD @"com.cesar.ADVoiceChatDemo.password"
#define  KEY_UUID @"com.cesar.ADVoiceChatDemo.uuid"

#define BGColor     @"f4f4f4"
#define StatusBarColor   @"67A1F1"
#define MainColor   @"2584FF"
#define LineColor   @"cdcdcd"

#define HEIGHT_STATUSBAR            (IS_IPHONE58INCH ? 44 : 20)
#define HEIGHT_TABBAR               (IS_IPHONE58INCH ? 83 : 49)
#define HEIGHT_NAVBAR               (IS_IPHONE58INCH ? 88 : 64)

#define BORDER_WIDTH_1PX            ([[UIScreen mainScreen] scale] > 0.0 ? 1.0 / [[UIScreen mainScreen] scale] : 1.0)

#define WS(weakSelf)  __weak __typeof(&*self)weakSelf = self;
#define RGBA_COLOR(R, G, B, A) [UIColor colorWithRed:((R) / 255.0f) green:((G) / 255.0f) blue:((B) / 255.0f) alpha:A]

//聊天相关
#define videoViewH ScreenHeight * 0.64 // 录制视频视图高度
#define videoViewX ScreenHeight * 0.36 // 录制视频视图X

#define     CHATBOX_BUTTON_WIDTH        37
#define     HEIGHT_TEXTVIEW             HEIGHT_TABBAR * 0.74
#define     MAX_TEXTVIEW_HEIGHT         104
#define     HEIGHT_CHATBOXVIEW          215

#define kVideoType @".mp4"        // video类型
#define kRecoderType @".wav"
#define kChatVideoPath @"Chat/Video"  // video子路径

#define MessageFont [UIFont systemFontOfSize:15.0]
#define ADRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16)) / 255.0 green:((float)((rgbValue & 0xFF00) >> 8)) / 255.0 blue:((float)(rgbValue & 0xFF)) / 255.0 alpha:1.0]

#endif /* Define_h */
