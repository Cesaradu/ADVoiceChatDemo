//
//  ADChatBoxViewController.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatBoxViewController.h"
#import "ADChatBoxMoreView.h"
#import "ADChatBoxFaceView.h"
#import "ADMessage.h"
#import "ADMediaManager.h"
#import "ADVideoView.h"
#import "ADMessageConst.h"
#import "ADVideoManager.h"
#import "ADDocumentViewController.h"
#import "ADTools.h"

@interface ADChatBoxViewController () <ADChatBoxDelegate, ADChatBoxMoreViewDelegate, UINavigationControllerDelegate,  UIImagePickerControllerDelegate, ADDocumentDelegate>

@property (nonatomic, assign) CGRect keyboardFrame;

//@property (nonatomic, strong) ADChatBox *chatBox;
/** chatBar more view */
@property (nonatomic, strong) ADChatBoxMoreView *chatBoxMoreView;
/** emoji face */
@property (nonatomic, strong) ADChatBoxFaceView *chatBoxFaceView;
/** 录音文件名 */
@property (nonatomic, copy) NSString *recordName;
@property (nonatomic, strong) UIImagePickerController *imagePicker;

@property (nonatomic, weak) ADVideoView *videoView;

@end

@implementation ADChatBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.chatBox];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardFrameWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

#pragma mark - Public Methods

- (BOOL)resignFirstResponder {
    if (self.chatBox.status == ADChatBoxStatusShowVideo) { // 录制视频状态
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
            } completion:^(BOOL finished) {
                [self.videoView removeFromSuperview]; // 移除video视图
                self.chatBox.status = ADChatBoxStatusNothing;//同时改变状态
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [[ADVideoManager shareManager] exit];  // 防止内存泄露
                });
            }];
        }
        return [super resignFirstResponder];
    }
    if (self.chatBox.status != ADChatBoxStatusNothing && self.chatBox.status != ADChatBoxStatusShowVoice) {
        [self.chatBox resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
            [UIView animateWithDuration:0.3 animations:^{
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
                [self.chatBoxMoreView removeFromSuperview];
                // 状态改变
                self.chatBox.status = ADChatBoxStatusNothing;
            }];
        }
        
    }
    return [super resignFirstResponder];
}

- (BOOL)becomeFirstResponder {
    return [super becomeFirstResponder];
}

- (void)routerEventWithName:(NSString *)eventName userInfo:(NSDictionary *)userInfo {
    if ([eventName isEqualToString:ADRouterEventVideoRecordExit]) {
        [self resignFirstResponder];
    } else if ([eventName isEqualToString:ADRouterEventVideoRecordFinish]) {
        NSString *videoPath = userInfo[VideoPathKey];
        [self resignFirstResponder];
        if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendVideoMessage:)]) {
            [_delegate chatBoxViewController:self sendVideoMessage:videoPath];
        }
    } else if ([eventName isEqualToString:ADRouterEventVideoRecordCancel]) {
        NSLog(@"record cancel");
    }
}

#pragma mark - Private Methods
- (NSString *)currentRecordFileName {
    NSTimeInterval timeInterval = [[NSDate date] timeIntervalSince1970];
    NSString *fileName = [NSString stringWithFormat:@"%ld",(long)timeInterval];
    return fileName;
}

- (void)keyboardWillHide:(NSNotification *)notification {
    self.keyboardFrame = CGRectZero;
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
        _chatBox.status = ADChatBoxStatusNothing;
    }
}

- (void)keyboardFrameWillChange:(NSNotification *)notification {
    self.keyboardFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    if (_chatBox.status == ADChatBoxStatusShowKeyboard && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        return;
    }
    else if ((_chatBox.status == ADChatBoxStatusShowFace || _chatBox.status == ADChatBoxStatusShowMore) && self.keyboardFrame.size.height <= HEIGHT_CHATBOXVIEW) {
        return;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: self.keyboardFrame.size.height + HEIGHT_TABBAR];
        _chatBox.status = ADChatBoxStatusShowKeyboard; // 状态改变
    }
}

// 将要弹出视频视图
- (void)videoViewWillAppear {
    ADVideoView *videoView = [[ADVideoView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, videoViewH)];
    [self.view insertSubview:videoView aboveSubview:self.chatBox];
    self.videoView = videoView;
    videoView.hidden = YES;
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didVideoViewAppeared:)]) {
        [_delegate chatBoxViewController:self didVideoViewAppeared:videoView];
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Getter and Setter
- (ADChatBox *) chatBox {
    if (_chatBox == nil) {
        _chatBox = [[ADChatBox alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, HEIGHT_TABBAR)];
        _chatBox.delegate = self;
    }
    return _chatBox;
}

- (ADChatBoxFaceView *)chatBoxFaceView {
    if (nil == _chatBoxFaceView) {
        _chatBoxFaceView = [[ADChatBoxFaceView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, ScreenWidth, HEIGHT_CHATBOXVIEW)];
    }
    return _chatBoxFaceView;
}

- (ADChatBoxMoreView *)chatBoxMoreView {
    if (nil == _chatBoxMoreView) {
        _chatBoxMoreView = [[ADChatBoxMoreView alloc] initWithFrame:CGRectMake(0, HEIGHT_TABBAR, ScreenWidth, HEIGHT_CHATBOXVIEW)];
        _chatBoxMoreView.delegate = self;
        // 创建Item
        ADChatBoxMoreViewItem *photosItem = [ADChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"照片"
                                                                                        imageName:@"sharemore_pic"];
        ADChatBoxMoreViewItem *takePictureItem = [ADChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"拍摄"
                                                                                             imageName:@"sharemore_video"];
        ADChatBoxMoreViewItem *videoItem = [ADChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"小视频"
                                                                                       imageName:@"sharemore_sight"];
        ADChatBoxMoreViewItem *docItem   = [ADChatBoxMoreViewItem createChatBoxMoreItemWithTitle:@"文件" imageName:@"sharemore_wallet"];
        [_chatBoxMoreView setItems:[[NSMutableArray alloc] initWithObjects:photosItem, takePictureItem, videoItem,docItem, nil]];
    }
    return _chatBoxMoreView;
}

- (UIImagePickerController *)imagePicker
{
    if (nil == _imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
        _imagePicker.modalPresentationStyle = UIModalPresentationCustom;
        _imagePicker.view.backgroundColor = [UIColor whiteColor];
        [_imagePicker.navigationBar setBackgroundImage:[UIImage imageNamed:@"daohanglanbeijing"] forBarMetrics:UIBarMetricsDefault];
        _imagePicker.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
    }
    return _imagePicker;
}

#pragma mark - TLChatBoxMoreViewDelegate

- (void) chatBoxMoreView:(ADChatBoxMoreView *)chatBoxMoreView
           didSelectItem:(ADChatBoxItem)itemType
{
    if (itemType == ADChatBoxItemAlbum) {       // 相册
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
            self.imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:self.imagePicker animated:YES completion:nil];
        } else {
            NSLog(@"photLibrary is not available!");
        }
    } else if (itemType == ADChatBoxItemCamera){    // camera
        if (![ADTools hasPermissionToGetCamera]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许WeChat访问你的相机。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
                self.imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                [self presentViewController:self.imagePicker animated:YES completion:nil];
            } else {
                NSLog(@"camera is no available!");
            }
        }
    } else if (itemType == ADChatBoxItemVideo) {
        [self resignFirstResponder];
        if (![[ADVideoManager shareManager] canRecordViedo]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在iPhone的“设置-隐私”选项中，允许WeChat访问你的摄像头和麦克风。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        } else {
            [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(videoViewWillAppear) userInfo:nil repeats:NO]; // 待动画完成
        }
    } else if (itemType == ADChatBoxItemDoc) {
        ADDocumentViewController *docVC = [[ADDocumentViewController alloc] init];
        docVC.delegate = self;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:docVC];
        [self presentViewController:nav animated:YES completion:nil];
    }
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    //    NSString *mediaType = info[UIImagePickerControllerMediaType];
    //    if ([mediaType isEqualToString:(NSString *)kUTTypeMovie]) {
    //        ICLog(@"movie");
    //    } else {
    UIImage *orgImage = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
    // 图片压缩后再上传服务器
    // 保存路径
    UIImage *simpleImg = [UIImage simpleImage:orgImage];
    NSString *filePaht = [[ADMediaManager sharedManager] saveImage:simpleImg];
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendImageMessage:imagePath:)]) {
        [_delegate chatBoxViewController:self sendImageMessage:simpleImg imagePath:filePaht];
    }
    //    }
}


#pragma mark - ADChatBoxDelegate

/**
 *  输入框状态改变
 *
 *  @param chatBox    chatBox
 *  @param fromStatus 起始状态
 *  @param toStatus   目的状态
 */
- (void)chatBox:(ADChatBox *)chatBox changeStatusForm:(ADChatBoxStatus)fromStatus to:(ADChatBoxStatus)toStatus
{
    if (toStatus == ADChatBoxStatusShowKeyboard) {  // 显示键盘
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.chatBoxFaceView removeFromSuperview];
            [self.chatBoxMoreView removeFromSuperview];
        });
        return;
    } else if (toStatus == ADChatBoxStatusShowVoice) {    // 语音输入按钮
        [UIView animateWithDuration:0.3 animations:^{
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR];
            }
        } completion:^(BOOL finished) {
            [self.chatBoxFaceView removeFromSuperview];
            [self.chatBoxMoreView removeFromSuperview];
        }];
    } else if (toStatus == ADChatBoxStatusShowFace) {     // 表情面板
        if (fromStatus == ADChatBoxStatusShowVoice || fromStatus == ADChatBoxStatusNothing) {
            self.chatBoxFaceView.y = HEIGHT_TABBAR;
            [self.view addSubview:self.chatBoxFaceView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR + HEIGHT_CHATBOXVIEW];
                }
            }];
        } else {  // 表情高度变化
            self.chatBoxFaceView.y = HEIGHT_TABBAR + HEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.chatBoxFaceView];
            [UIView animateWithDuration:0.3 animations:^{
                self.chatBoxFaceView.y = HEIGHT_TABBAR;
            } completion:^(BOOL finished) {
                [self.chatBoxMoreView removeFromSuperview];
            }];
            if (fromStatus != ADChatBoxStatusShowMore) {
                [UIView animateWithDuration:0.2 animations:^{
                    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                        [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR + HEIGHT_CHATBOXVIEW];
                    }
                }];
            }
        }
    } else if (toStatus == ADChatBoxStatusShowMore) {
        if (fromStatus == ADChatBoxStatusShowVoice || fromStatus == ADChatBoxStatusNothing) {
            self.chatBoxMoreView.y = HEIGHT_TABBAR;
            [self.view addSubview:self.chatBoxMoreView];
            [UIView animateWithDuration:0.3 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR + HEIGHT_CHATBOXVIEW];
                }
            }];
        } else {
            self.chatBoxMoreView.y = HEIGHT_TABBAR + HEIGHT_CHATBOXVIEW;
            [self.view addSubview:self.chatBoxMoreView];
            [UIView animateWithDuration:0.3 animations:^{
                self.chatBoxMoreView.y = HEIGHT_TABBAR;
            } completion:^(BOOL finished) {
                [self.chatBoxFaceView removeFromSuperview];
            }];
            
            [UIView animateWithDuration:0.2 animations:^{
                if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
                    [_delegate chatBoxViewController:self didChangeChatBoxHeight:HEIGHT_TABBAR + HEIGHT_CHATBOXVIEW];
                }
            }];
        }
    }
    
}


- (void)chatBox:(ADChatBox *)chatBox sendTextMessage:(NSString *)textMessage
{
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendTextMessage:)]) {
        [_delegate chatBoxViewController:self sendTextMessage:textMessage];
    }
}

/**
 *  输入框高度改变
 *
 *  @param chatBox chatBox
 *  @param height  height
 */
- (void)chatBox:(ADChatBox *)chatBox changeChatBoxHeight:(CGFloat)height
{
    self.chatBoxFaceView.y = height;
    self.chatBoxMoreView.y = height;
    if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:didChangeChatBoxHeight:)]) {
        float h = (self.chatBox.status == ADChatBoxStatusShowFace ? HEIGHT_CHATBOXVIEW : self.keyboardFrame.size.height ) + height;
        [_delegate chatBoxViewController:self didChangeChatBoxHeight: h];
    }
    
}

- (void)chatBoxDidStartRecordingVoice:(ADChatBox *)chatBox
{
    self.recordName = [self currentRecordFileName];
    //    if ([_delegate respondsToSelector:@selector(voiceDidStartRecording)]) {
    //        [_delegate voiceDidStartRecording];
    //    }
    [[ADRecordManager shareManager] startRecordingWithFileName:self.recordName completion:^(NSError *error) {
        if (error) {   // 加了录音权限的判断
        } else {
            if ([_delegate respondsToSelector:@selector(voiceDidStartRecording)]) {
                [_delegate voiceDidStartRecording];
            }
        }
    }];
}

- (void)chatBoxDidStopRecordingVoice:(ADChatBox *)chatBox {
    __weak typeof(self) weakSelf = self;
    [[ADRecordManager shareManager] stopRecordingWithCompletion:^(NSString *recordPath) {
        if ([recordPath isEqualToString:shortRecord]) {
            if ([_delegate respondsToSelector:@selector(voiceRecordSoShort)]) {
                [_delegate voiceRecordSoShort];
            }
            [[ADRecordManager shareManager] removeCurrentRecordFile:weakSelf.recordName];
        } else {    // send voice message
            if (_delegate && [_delegate respondsToSelector:@selector(chatBoxViewController:sendVoiceMessage:)]) {
                [_delegate chatBoxViewController:weakSelf sendVoiceMessage:recordPath];
            }
        }
    }];
}

- (void)chatBoxDidCancelRecordingVoice:(ADChatBox *)chatBox {
    if ([_delegate respondsToSelector:@selector(voiceDidCancelRecording)]) {
        [_delegate voiceDidCancelRecording];
    }
    [[ADRecordManager shareManager] removeCurrentRecordFile:self.recordName];
}

- (void)chatBoxDidDrag:(BOOL)inside {
    if ([_delegate respondsToSelector:@selector(voiceWillDragout:)]) {
        [_delegate voiceWillDragout:inside];
    }
}

#pragma mark - ICDocumentDelegate
- (void)selectedFileName:(NSString *)fileName {
    if ([self.delegate respondsToSelector:@selector(chatBoxViewController:sendFileMessage:)]) {
        [self.delegate chatBoxViewController:self sendFileMessage:fileName];
    }
}

@end
