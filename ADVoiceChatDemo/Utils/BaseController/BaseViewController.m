//
//  BaseViewController.m
//  BaseFramework
//
//  Created by hztuen on 17/3/2.
//  Copyright © 2017年 Cesar. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController () <MBProgressHUDDelegate>

@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation BaseViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES; //隐藏导航栏
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/**
 适配 给定4.7寸屏尺寸，适配4,5.5,5.8寸屏尺寸
 5.8寸iPhonex 屏宽也是375，适配暂时跟4.7寸一样
 */
- (float)Suit:(float)MySuit {
    (IS_IPHONE4INCH||IS_IPHONE35INCH)?(MySuit=MySuit/Suit4Inch):((IS_IPHONE55INCH)?(MySuit=MySuit*Suit55Inch):MySuit);
    return MySuit;
}

/**
 适配 给定4.7寸屏字号，适配4(-1)和5.5(+1)寸屏字号
 */
- (float)SuitFont:(float)font {
    (IS_IPHONE4INCH||IS_IPHONE35INCH)?(font=font-1):((IS_IPHONE55INCH)?(font=font+1):font);
    return font;
}

- (void)buildNaviBarBackButton {
    UIButton *leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftBtn setImage:[UIImage imageNamed:@"gy_fh_icon"] forState:UIControlStateNormal];
    leftBtn.frame = CGRectMake(0, 0, 44, 44);
    [leftBtn setImageEdgeInsets:UIEdgeInsetsMake(0, -15, 0, 15)];
    UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc] initWithCustomView:leftBtn];
    [leftBtn addTarget:self action:@selector(clickNaviBarBackButton) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = leftBtnItem;
    
    if(([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0?15:0))
    {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 0;
        self.navigationItem.leftBarButtonItems = @[negativeSpacer, leftBtnItem];
    } else {
        self.navigationItem.leftBarButtonItem = leftBtnItem;
    }
    
}

// 返回按钮的方法
- (void)clickNaviBarBackButton {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark 获取url图片大小
- (CGSize)getImageSizeWithURL:(id)imageURL {
    NSURL* URL = nil;
    if([imageURL isKindOfClass:[NSURL class]]){
        URL = imageURL;
    }
    if([imageURL isKindOfClass:[NSString class]]){
        URL = [NSURL URLWithString:imageURL];
    }
    if(URL == nil)
        return CGSizeZero;                  // url不正确返回CGSizeZero
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:URL];
    NSString* pathExtendsion = [URL.pathExtension lowercaseString];
    
    CGSize size = CGSizeZero;
    if([pathExtendsion isEqualToString:@"png"]){
        size =  [self getPNGImageSizeWithRequest:request];
    }
    else if([pathExtendsion isEqual:@"gif"])
    {
        size =  [self getGIFImageSizeWithRequest:request];
    }
    else{
        size = [self getJPGImageSizeWithRequest:request];
    }
    if(CGSizeEqualToSize(CGSizeZero, size))                    // 如果获取文件头信息失败,发送异步请求请求原图
    {
        NSData* data = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL:URL] returningResponse:nil error:nil];
        UIImage* image = [UIImage imageWithData:data];
        if(image)
        {
            size = image.size;
        }
    }
    return size;
}

//  获取PNG图片的大小
- (CGSize)getPNGImageSizeWithRequest:(NSMutableURLRequest*)request {
    [request setValue:@"bytes=16-23" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 8) {
        int w1 = 0, w2 = 0, w3 = 0, w4 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        [data getBytes:&w3 range:NSMakeRange(2, 1)];
        [data getBytes:&w4 range:NSMakeRange(3, 1)];
        int w = (w1 << 24) + (w2 << 16) + (w3 << 8) + w4;
        int h1 = 0, h2 = 0, h3 = 0, h4 = 0;
        [data getBytes:&h1 range:NSMakeRange(4, 1)];
        [data getBytes:&h2 range:NSMakeRange(5, 1)];
        [data getBytes:&h3 range:NSMakeRange(6, 1)];
        [data getBytes:&h4 range:NSMakeRange(7, 1)];
        int h = (h1 << 24) + (h2 << 16) + (h3 << 8) + h4;
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//  获取gif图片的大小
- (CGSize)getGIFImageSizeWithRequest:(NSMutableURLRequest*)request {
    [request setValue:@"bytes=6-9" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    if(data.length == 4) {
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0, 1)];
        [data getBytes:&w2 range:NSMakeRange(1, 1)];
        short w = w1 + (w2 << 8);
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(2, 1)];
        [data getBytes:&h2 range:NSMakeRange(3, 1)];
        short h = h1 + (h2 << 8);
        return CGSizeMake(w, h);
    }
    return CGSizeZero;
}

//  获取jpg图片的大小
- (CGSize)getJPGImageSizeWithRequest:(NSMutableURLRequest*)request {
    [request setValue:@"bytes=0-209" forHTTPHeaderField:@"Range"];
    NSData* data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    if ([data length] <= 0x58) {
        return CGSizeZero;
    }
    
    if ([data length] < 210) {// 肯定只有一个DQT字段
        short w1 = 0, w2 = 0;
        [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
        [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
        short w = (w1 << 8) + w2;
        short h1 = 0, h2 = 0;
        [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
        [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
        short h = (h1 << 8) + h2;
        return CGSizeMake(w, h);
    } else {
        short word = 0x0;
        [data getBytes:&word range:NSMakeRange(0x15, 0x1)];
        if (word == 0xdb) {
            [data getBytes:&word range:NSMakeRange(0x5a, 0x1)];
            if (word == 0xdb) {// 两个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0xa5, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0xa6, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0xa3, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0xa4, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            } else {// 一个DQT字段
                short w1 = 0, w2 = 0;
                [data getBytes:&w1 range:NSMakeRange(0x60, 0x1)];
                [data getBytes:&w2 range:NSMakeRange(0x61, 0x1)];
                short w = (w1 << 8) + w2;
                short h1 = 0, h2 = 0;
                [data getBytes:&h1 range:NSMakeRange(0x5e, 0x1)];
                [data getBytes:&h2 range:NSMakeRange(0x5f, 0x1)];
                short h = (h1 << 8) + h2;
                return CGSizeMake(w, h);
            }
        } else {
            return CGSizeZero;
        }
    }
}

//NSData类型的Mac地址转换成字符串
- (NSString *)changeDataToString:(NSData *)macAddress {
    Byte *testByte = (Byte *)[macAddress bytes];
    NSMutableString *hexString = [[NSMutableString alloc] init];
    for (int i = 0; i < 6; i++) {
        if (hexString.length == 0) {
            [hexString appendString:[NSString stringWithFormat:@"%0.2hhx", testByte[i]]];
        } else {
            [hexString appendString:[NSString stringWithFormat:@":%0.2hhx", testByte[i]]];
        }
    }
    return (NSString *)hexString;
}

//字典转字符串
- (NSString *)dictionaryToJson:(NSDictionary *)dic {
    
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 比较两个版本号的大小
 @param v1 服务器获取的版本号
 @param v2 app当前版本号
 @return 版本号相等,返回0; v1小于v2,返回-1; 否则返回1(有更新).
 */
- (NSInteger)compareServerVersion:(NSString *)v1 withCurrentVersion:(NSString *)v2 {
    // 都为空，相等，返回0
    if (!v1 && !v2) {
        return 0;
    }
    
    // v1为空，v2不为空，返回-1
    if (!v1 && v2) {
        return -1;
    }
    
    // v2为空，v1不为空，返回1
    if (v1 && !v2) {
        return 1;
    }
    
    // 获取版本号字段
    NSArray *v1Array = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Array = [v2 componentsSeparatedByString:@"."];
    // 取字段最少的，进行循环比较
    NSInteger smallCount = (v1Array.count > v2Array.count) ? v2Array.count : v1Array.count;
    
    for (int i = 0; i < smallCount; i++) {
        NSInteger value1 = [[v1Array objectAtIndex:i] integerValue];
        NSInteger value2 = [[v2Array objectAtIndex:i] integerValue];
        if (value1 > value2) {
            // v1版本字段大于v2版本字段，返回1
            return 1;
        } else if (value1 < value2) {
            // v2版本字段大于v1版本字段，返回-1
            return -1;
        }
        
        // 版本相等，继续循环。
    }
    
    // 版本可比较字段相等，则字段多的版本高于字段少的版本。
    if (v1Array.count > v2Array.count) {
        return 1;
    } else if (v1Array.count < v2Array.count) {
        return -1;
    } else {
        return 0;
    }
    
    return 0;
}

#pragma mark - MBProgressHUD
- (void)showLoadingViewOnWindow:(NSString *)message {
    if (!_hud) {
        AppDelegate * delegat = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _hud = [[MBProgressHUD alloc] initWithView:delegat.window];
        [delegat.window addSubview:_hud];
    }
    _hud.layer.cornerRadius = 4;
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:[self SuitFont:16]];
    if ([NSString isNULL:message]) {
        _hud.detailsLabel.text = NSLocalizedString(@"正在加载", nil);
    } else {
        _hud.detailsLabel.text = message;
    }
    _hud.delegate = self;
    [_hud showAnimated:YES];
}

- (void)showLoadingViewOnView:(NSString *)message {
    if (!_hud) {
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
    }
    _hud.layer.cornerRadius = 4;
    _hud.mode = MBProgressHUDModeIndeterminate;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:[self SuitFont:16]];
    if ([NSString isNULL:message]) {
        _hud.detailsLabel.text = NSLocalizedString(@"正在加载", nil);
    } else {
        _hud.detailsLabel.text = message;
    }
    _hud.delegate = self;
    [_hud showAnimated:YES];
}

- (void)hideLoadingView {
    [_hud hideAnimated:NO afterDelay:0];
}

- (void)showSuccessView:(NSString *)message {
    if (!_hud) {
        AppDelegate * delegat = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _hud = [[MBProgressHUD alloc] initWithView:delegat.window];
        [delegat.window addSubview:_hud];
    }
    _hud.layer.cornerRadius = 4;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_yes"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:[self SuitFont:16]];
    _hud.detailsLabel.text = message;
    _hud.delegate = self;
    
    [_hud showAnimated:YES];
    [_hud hideAnimated:NO afterDelay:1.5];
}

- (void)showSuccessView:(NSString *)message todo:(SEL)todo {
    [self showSuccessView:message];
    [self performSelector:todo withObject:nil afterDelay:1.5];
}

- (void)showErrorView:(NSString*)message {
    if (!_hud) {
        AppDelegate * delegat = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _hud = [[MBProgressHUD alloc] initWithView:delegat.window];
        [delegat.window addSubview:_hud];
    }
    _hud.layer.cornerRadius = 4;
    _hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"icon_no"]];
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:[self SuitFont:16]];
    _hud.detailsLabel.text = message;
    _hud.delegate = self;
    
    [_hud showAnimated:YES];
    [_hud hideAnimated:NO afterDelay:1.5];
}

- (void)showErrorView:(NSString *)message todo:(SEL)todo {
    [self showErrorView:message];
    [self performSelector:todo withObject:nil afterDelay:1.5];
}

- (void)showNormalView:(NSString *)message {
    if (!_hud) {
        AppDelegate * delegat = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        _hud = [[MBProgressHUD alloc] initWithView:delegat.window];
        [delegat.window addSubview:_hud];
    }
    _hud.layer.cornerRadius = 4;
    _hud.mode = MBProgressHUDModeCustomView;
    _hud.detailsLabel.font = [UIFont systemFontOfSize:[self SuitFont:16]];
    _hud.detailsLabel.text = message;
    _hud.delegate = self;
    
    [_hud showAnimated:YES];
    [_hud hideAnimated:NO afterDelay:1.5];
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    [_hud removeFromSuperview];
    _hud.delegate = nil;
    _hud = nil;
}

//设置状态栏颜色
- (void)setStatusBarBackgroundColor:(UIColor *)color {
    UIView *statusBar = [[[UIApplication sharedApplication] valueForKey:@"statusBarWindow"] valueForKey:@"statusBar"];
    if ([statusBar respondsToSelector:@selector(setBackgroundColor:)]) {
        statusBar.backgroundColor = color;
    }
}

- (UIImage *)cutImageToImage:(UIImage *)originalImage AndImageKB:(CGFloat)imageKB {
    float scale;
    NSData * imageData = UIImageJPEGRepresentation(originalImage,1);
    float length = [imageData length]/1000;
    scale = imageKB/length;
    if(scale>1 || scale == 0) {
        return originalImage;
    }
    CGSize size = originalImage.size;
    int wi=size.width*scale;
    int hi=size.height*scale;
    
    CGSize newSize=CGSizeMake(wi, hi);
    NSLog(@"newSize = %@", NSStringFromCGSize(newSize));
    UIGraphicsBeginImageContext(newSize);
    [originalImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    NSData * imageData2 = UIImageJPEGRepresentation(newImage,0.5);
    UIImage *lastImage=[UIImage imageWithData:imageData2 scale:1];
    UIGraphicsEndImageContext();
    return lastImage;
}

- (BOOL)isPhone:(NSString *)phone {
    if (phone.length == 11) {
        NSString * mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
        NSString * cm = @"^1(34[0-8]|(3[5-9]|47|5[0127-9]|78|8[2-478])\\d)\\d{7}$";
        NSString * cu = @"^1(3[0-2]|5[56]|76|8[56])\\d{8}$";
        NSString * ct = @"^1((33|53|7[39]|8[019])[0-9]|349)\\d{7}$";
        NSPredicate * regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
        NSPredicate * regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cm];
        NSPredicate * regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", cu];
        NSPredicate * regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", ct];
        if (([regextestmobile evaluateWithObject:phone] == YES)
            || ([regextestcm evaluateWithObject:phone] == YES)
            || ([regextestct evaluateWithObject:phone] == YES)
            || ([regextestcu evaluateWithObject:phone] == YES))
        {
            if([regextestcm evaluateWithObject:phone] == YES) {
                
            } else if([regextestct evaluateWithObject:phone] == YES) {
                
            } else if ([regextestcu evaluateWithObject:phone] == YES) {
                
            } else {
                
            }
            
            return YES;
        }
    }
    return NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
