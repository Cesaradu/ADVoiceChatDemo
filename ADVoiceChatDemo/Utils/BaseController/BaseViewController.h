//
//  BaseViewController.h
//  BaseFramework
//
//  Created by hztuen on 17/3/2.
//  Copyright © 2017年 Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

@interface BaseViewController : UIViewController

// 适配界面
- (float)Suit:(float)MySuit;

// 适配字号
- (float)SuitFont:(float)font;

//左侧返回按钮
- (void)buildNaviBarBackButton;
- (void)clickNaviBarBackButton;

//计算网路请求图片大小
- (CGSize)getImageSizeWithURL:(id)imageURL;

//NSData类型的Mac地址转换成字符串
- (NSString *)changeDataToString:(NSData *)macAddress;

//字典转字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic;

//版本判断
- (NSInteger)compareServerVersion:(NSString *)v1 withCurrentVersion:(NSString *)v2;

#pragma mark - MBProgressHUD
//加载
- (void)showLoadingViewOnWindow:(NSString *)message;
- (void)showLoadingViewOnView:(NSString *)message;

//接口请求成功
- (void)showSuccessView:(NSString *)message;
- (void)showSuccessView:(NSString *)message todo:(SEL)todo;

//接口请求失败
- (void)showErrorView:(NSString *)message;
- (void)showErrorView:(NSString *)message todo:(SEL)todo;

//普通
- (void)showNormalView:(NSString *)message;

//隐藏
- (void)hideLoadingView;

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color;

//判断是否为电话号码
- (BOOL)isPhone:(NSString *)phone;

//返回前一个页面
- (void)back;

@end
