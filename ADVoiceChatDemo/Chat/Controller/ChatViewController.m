//
//  ChatViewController.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/10.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ChatViewController.h"
#import "ADChatBoxViewController.h"
#import "ADChatMessageImageCell.h"
#import "ADChatMessageTextCell.h"
#import "ADChatMessageVideoCell.h"
#import "ADChatMessageVoiceCell.h"
#import "ADChatMessageBaseCell.h"
#import "ADChatMessageFileCell.h"
#import "ADChatSystemCell.h"
#import "ADMessageFrame.h"
#import "ADMessage.h"
#import "ADMessageModel.h"
#import "ADMediaManager.h"
#import "ADVideoView.h"
#import "ADVideoManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "ADFileTool.h"
#import "ADChatMessageSyeCell.h"
#import "ADVoiceHud.h"
#import "VoiceConverter.h"
#import "ADVideoManager.h"
#import "ADAVPlayer.h"
#import "ADPhotoBrowserViewController.h"
#import "ADVideoManager.h"
#import "ADMessageHelper.h"
#import "FMDBManager.h"

@interface ChatViewController () <ADChatBoxViewControllerDelegate, UITableViewDelegate, UITableViewDataSource, ADRecordManagerDelegate, UIViewControllerTransitioningDelegate, UIViewControllerAnimatedTransitioning, BaseCellDelegate>
{
    CGRect _smallRect;
    CGRect _bigRect;
    
    UIMenuItem * _copyMenuItem;
    UIMenuItem * _deleteMenuItem;
    UIMenuItem * _forwardMenuItem;
    UIMenuItem * _recallMenuItem;
    NSIndexPath *_longIndexPath;
    
    BOOL   _isKeyBoardAppear;     // 键盘是否弹出来了
}

@property (nonatomic, strong) ADChatBoxViewController *chatBoxVC;

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITextView *textView;
/** 数据源 */
@property (nonatomic, strong) NSMutableArray *dataSource;
/** voice path */
@property (nonatomic, copy) NSString *voicePath;

@property (nonatomic, strong) UIImageView *currentVoiceIcon;
@property (nonatomic, strong) UIImageView *presentImageView;
@property (nonatomic, assign)  BOOL presentFlag;  // 是否model出控制器
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) ADVoiceHud *voiceHud;

@property (nonatomic, assign) NSInteger message_id; // 本地调试用，实际开发从服务端获取

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.message_id = 0;
    [self buildNaviBarBackButton];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"微聊详情";
    [self setupUI];
    [self registerCell];
    //先从本地数据库读取消息记录
    [self loadDataSourceFromDatabase];
}

- (void)loadDataSourceFromDatabase {
    //从本地数据库取数据
    self.dataSource = [[FMDBManager sharedFMDBManager] getAllMessages];
    NSLog(@"dataSource = %@", self.dataSource);
    ADMessageFrame *lastMsg = self.dataSource.lastObject;
    self.message_id = [lastMsg.model.message_id integerValue];
    [self.tableView reloadData];
    [self scrollToBottom];
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor colorWithHexString:BGColor];
    // 注意添加顺序
    [self addChildViewController:self.chatBoxVC];
    [self.view addSubview:self.chatBoxVC.view];
    [self.view addSubview:self.tableView];
    
    self.tableView.backgroundColor = [UIColor colorWithHexString:BGColor];
    self.tableView.frame = CGRectMake(0, HEIGHT_NAVBAR, self.view.width, ScreenHeight - HEIGHT_TABBAR - HEIGHT_NAVBAR);
    
    //iOS 11
    if (@available(iOS 11.0, *)) {
        self.tableView.estimatedRowHeight = 0;
        self.tableView.estimatedSectionHeaderHeight = 0;
        self.tableView.estimatedSectionFooterHeight = 0;
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        self.automaticallyAdjustsScrollViewInsets = NO;
    }
}

- (void)registerCell {
    [self.tableView registerClass:[ADChatMessageTextCell class] forCellReuseIdentifier:TypeText];
    [self.tableView registerClass:[ADChatMessageImageCell class] forCellReuseIdentifier:TypePic];
    [self.tableView registerClass:[ADChatMessageVideoCell class] forCellReuseIdentifier:TypeVideo];
    [self.tableView registerClass:[ADChatMessageVoiceCell class] forCellReuseIdentifier:TypeVoice];
    [self.tableView registerClass:[ADChatMessageFileCell class] forCellReuseIdentifier:TypeFile];
}

#pragma mark - Tableview data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    id obj                            = self.dataSource[indexPath.row];
    if ([obj isKindOfClass:[NSString class]]) {
        return nil;
    } else {
        ADMessageFrame *modelFrame     = (ADMessageFrame *)obj;
        NSString *ID                   = modelFrame.model.message.type;
        if ([ID isEqualToString:TypeSystem]) {
            ADChatSystemCell *cell = [ADChatSystemCell cellWithTableView:tableView reusableId:ID];
            cell.messageF              = modelFrame;
            return cell;
        }
        ADChatMessageBaseCell *cell    = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.longPressDelegate         = self;
        [[ADMediaManager sharedManager] clearReuseImageMessage:cell.modelFrame.model];
        cell.modelFrame                = modelFrame;
        return cell;
    }
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    ADMessageFrame *messageF = [self.dataSource objectAtIndex:indexPath.row];
    return messageF.cellHight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.chatBoxVC resignFirstResponder];
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.chatBoxVC resignFirstResponder];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath*)indexPath {
    if ([cell isKindOfClass:[ADChatMessageVideoCell class]] && self) {
        ADChatMessageVideoCell *videoCell = (ADChatMessageVideoCell *)cell;
        [videoCell stopVideo];
    }
}

#pragma mark - ADChatBoxViewControllerDelegate
- (void) chatBoxViewController:(ADChatBoxViewController *)chatboxViewController
        didChangeChatBoxHeight:(CGFloat)height {
    self.chatBoxVC.view.top = self.view.bottom - height;
    self.tableView.height = ScreenHeight - height - HEIGHT_NAVBAR;
    if (height == HEIGHT_TABBAR) {
        [self.tableView reloadData];
        _isKeyBoardAppear  = NO;
    } else {
        [self scrollToBottom];
        _isKeyBoardAppear  = YES;
    }
    if (self.textView == nil) {
        self.textView = chatboxViewController.chatBox.textView;
    }
}

- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController didVideoViewAppeared:(ADVideoView *)videoView {
    [_chatBoxVC.view setFrame:CGRectMake(0, ScreenHeight - HEIGHT_TABBAR, ScreenWidth, ScreenHeight)];
    videoView.hidden = NO;
    [UIView animateWithDuration:0.5 animations:^{
        self.tableView.height = ScreenHeight - videoViewH - HEIGHT_NAVBAR;
        self.chatBoxVC.view.frame = CGRectMake(0, videoViewX + HEIGHT_NAVBAR, ScreenWidth, videoViewH);
        [self scrollToBottom];
    } completion:^(BOOL finished) { // 状态改变
        self.chatBoxVC.chatBox.status = ADChatBoxStatusShowVideo;
        // 在这里创建视频设配
        UIView *videoLayerView = [videoView viewWithTag:1000];
        UIView *placeholderView = [videoView viewWithTag:1001];
        [[ADVideoManager shareManager] setVideoPreviewLayer:videoLayerView];
        [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(videoPreviewLayerWillAppear:) userInfo:placeholderView repeats:NO];
        
    }];
}

- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController sendVideoMessage:(NSString *)videoPath {
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypeVideo messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:@"[视频]" path:videoPath fromName:@"发送者" fromHeadImage:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController sendFileMessage:(NSString *)fileName {
    NSString *lastName = [fileName originName];
    NSString*fileKey   = [fileName firstStringSeparatedByString:@"_"];
    NSString *content = [NSString stringWithFormat:@"[文件]%@",lastName];
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypeFile messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:content path:fileName fromName:@"发送者" fromHeadImage:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    NSString *path = [[ADFileTool fileMainPath] stringByAppendingPathComponent:fileName];
    double s = [ADFileTool fileSizeWithPath:path];
    NSNumber *x = [ADMessageHelper fileType:[fileName pathExtension]];
    if (!x) {
        x = @0;
    }
    NSDictionary *lnk = @{@"s":@((long)s),@"x":x,@"n":lastName};
    messageFrame.model.message.lnk = [lnk jsonString];
    messageFrame.model.message.fileKey = fileKey;
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

// send text message
- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController
               sendTextMessage:(NSString *)messageStr {
    if (messageStr && messageStr.length > 0) {
        [self sendTextMessageWithContent:messageStr];
        [self otherSendTextMessageWithContent:messageStr];
    }
}

- (void)sendTextMessageWithContent:(NSString *)messageStr {
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypeText messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:messageStr path:nil fromName:@"发送者" fromHeadImage:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageFrame isSender:YES];
    
    [self messageSendSucced:messageFrame];
}

- (void)otherSendTextMessageWithContent:(NSString *)messageStr {
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypeText messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:messageStr path:nil fromName:@"接收者" fromHeadImage:@"" fileKey:nil isSender:NO receivedSenderByYourself:NO];
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

// 增加数据源并刷新
- (void)addObject:(ADMessageFrame *)messageF
         isSender:(BOOL)isSender {
    [self.dataSource addObject:messageF];
    [self.tableView reloadData];
    if (isSender || _isKeyBoardAppear) {
        [self scrollToBottom];
    }
}

- (void)messageSendSucced:(ADMessageFrame *)messageF {
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        messageF.model.message.deliveryState = ADMessageDeliveryState_Delivered;
        [self.tableView reloadData];
        //更新数据库，发送状态变更
        [[FMDBManager sharedFMDBManager] updateMessage:messageF.model];
    });
}

// send image message
- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController
              sendImageMessage:(UIImage *)image
                     imagePath:(NSString *)imgPath {
    if (image && imgPath) {
        [self sendImageMessageWithImgPath:imgPath];
    }
}

- (void)sendImageMessageWithImgPath:(NSString *)imgPath {
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypePic messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:@"[图片]" path:imgPath fromName:@"发送者" fromHeadImage:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

// send voice message
- (void)chatBoxViewController:(ADChatBoxViewController *)chatboxViewController sendVoiceMessage:(NSString *)voicePath {
    [self timerInvalue]; // 销毁定时器
    self.voiceHud.hidden = YES;
    if (voicePath) {
        [self sendVoiceMessage:voicePath];
        [self otherSendVioceMessage:voicePath]; //调试用
    }
}

- (void)sendVoiceMessage:(NSString *)voicePath {
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypeVoice messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:@"[语音]" path:voicePath fromName:@"发送者" fromHeadImage:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

- (void)otherSendVioceMessage:(NSString *)voicePath {
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypeVoice messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:@"[语音]" path:voicePath fromName:@"接收者" fromHeadImage:@"" fileKey:nil isSender:NO receivedSenderByYourself:NO];
    [self addObject:messageFrame isSender:YES];
    [self messageSendSucced:messageFrame];
}

#pragma mark - baseCell delegate
- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer {
    if (longRecognizer.state == UIGestureRecognizerStateBegan) {
        CGPoint location       = [longRecognizer locationInView:self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:location];
        _longIndexPath         = indexPath;
        id object              = [self.dataSource objectAtIndex:indexPath.row];
        if (![object isKindOfClass:[ADMessageFrame class]]) return;
        ADChatMessageBaseCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        [self showMenuViewController:cell.bubbleView andIndexPath:indexPath message:cell.modelFrame.model];
    }
}

#pragma mark - public method
// 路由响应
- (void)routerEventWithName:(NSString *)eventName
                   userInfo:(NSDictionary *)userInfo {
    ADMessageFrame *modelFrame = [userInfo objectForKey:MessageKey];
    if ([eventName isEqualToString:ADRouterEventTextUrlTapEventName]) {
    } else if ([eventName isEqualToString:ADRouterEventImageTapEventName]) {
        _smallRect             = [[userInfo objectForKey:@"smallRect"] CGRectValue];
        _bigRect               =  [[userInfo objectForKey:@"bigRect"] CGRectValue];
        NSString *imgPath      = modelFrame.model.mediaPath;
        NSString *orgImgPath = [[ADMediaManager sharedManager] originImgPath:modelFrame];
        if ([ADFileTool fileExistsAtPath:orgImgPath]) {
            modelFrame.model.mediaPath = orgImgPath;
            imgPath                    = orgImgPath;
        }
        [self showLargeImageWithPath:imgPath withMessageF:modelFrame];
    } else if ([eventName isEqualToString:ADRouterEventVoiceTapEventName]) {
        
        UIImageView *imageView = (UIImageView *)userInfo[VoiceIcon];
        UIView *redView        = (UIView *)userInfo[RedView];
        [self chatVoiceTaped:modelFrame voiceIcon:imageView redView:redView];
    }
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

#pragma mark - voice & video
- (void)voiceDidCancelRecording {
    [self timerInvalue];
    self.voiceHud.hidden = YES;
}

- (void)voiceDidStartRecording {
    [self timerInvalue];
    self.voiceHud.hidden = NO;
    [self timer];
}

// 向外或向里移动
- (void)voiceWillDragout:(BOOL)inside {
    if (inside) {
        [_timer setFireDate:[NSDate distantPast]];
        _voiceHud.image  = [UIImage imageNamed:@"voice_1"];
    } else {
        [_timer setFireDate:[NSDate distantFuture]];
        self.voiceHud.animationImages  = nil;
        self.voiceHud.image = [UIImage imageNamed:@"cancelVoice"];
    }
}

- (void)progressChange {
    AVAudioRecorder *recorder = [[ADRecordManager shareManager] recorder] ;
    [recorder updateMeters];
    float power= [recorder averagePowerForChannel:0];//取得第一个通道的音频，注意音频强度范围时-160到0,声音越大power绝对值越小
    CGFloat progress = (1.0/160)*(power + 160);
    self.voiceHud.progress = progress;
}

- (void)voiceRecordSoShort {
    [self timerInvalue];
    self.voiceHud.animationImages = nil;
    self.voiceHud.image = [UIImage imageNamed:@"voiceShort"];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.voiceHud.hidden = YES;
    });
}

// play voice
- (void)chatVoiceTaped:(ADMessageFrame *)messageFrame
             voiceIcon:(UIImageView *)voiceIcon
               redView:(UIView *)redView {
    ADRecordManager *recordManager = [ADRecordManager shareManager];
    recordManager.playDelegate = self;
    // 文件路径
    NSString *voicePath = [self mediaPath:messageFrame.model.mediaPath];
    NSString *amrPath   = [[voicePath stringByDeletingPathExtension] stringByAppendingPathExtension:@"amr"];
    [VoiceConverter ConvertAmrToWav:amrPath wavSavePath:voicePath];
    if (messageFrame.model.message.status == 0){
        messageFrame.model.message.status = 1;
        redView.hidden = YES;
        //更新数据库，未读变为已读
        [[FMDBManager sharedFMDBManager] updateMessage:messageFrame.model];
    }
    if (self.voicePath) {
        if ([self.voicePath isEqualToString:voicePath]) { // the same recoder
            self.voicePath = nil;
            [[ADRecordManager shareManager] stopPlayRecorder:voicePath];
            [voiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
            return;
        } else {
            [self.currentVoiceIcon stopAnimating];
            self.currentVoiceIcon = nil;
        }
    }
    [[ADRecordManager shareManager] startPlayRecorder:voicePath];
    [voiceIcon startAnimating];
    self.voicePath = voicePath;
    self.currentVoiceIcon = voiceIcon;
}

// 移除录视频时的占位图片
- (void)videoPreviewLayerWillAppear:(NSTimer *)timer {
    UIView *placeholderView = (UIView *)[timer userInfo];
    [placeholderView removeFromSuperview];
}

#pragma mark - ADRecordManagerDelegate
- (void)voiceDidPlayFinished {
    self.voicePath = nil;
    ADRecordManager *manager = [ADRecordManager shareManager];
    manager.playDelegate = nil;
    [self.currentVoiceIcon stopAnimating];
    self.currentVoiceIcon = nil;
}

#pragma mark - UIViewControllerTransitioningDelegate
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    self.presentFlag = YES;
    return self;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    self.presentFlag = NO;
    return self;
}

#pragma mark - UIViewControllerAnimatedTransitioning
- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.5;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    if (self.presentFlag) {
        UIView *toView              = [transitionContext viewForKey:UITransitionContextToViewKey];
        self.presentImageView.frame = _smallRect;
        [[transitionContext containerView] addSubview:self.presentImageView];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            self.presentImageView.frame = _bigRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [self.presentImageView removeFromSuperview];
                [[transitionContext containerView] addSubview:toView];
                [transitionContext completeTransition:YES];
            }
        }];
    } else {
        ADPhotoBrowserViewController *photoVC = (ADPhotoBrowserViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
        UIImageView *iv     = photoVC.imageView;
        UIView *fromView    = [transitionContext viewForKey:UITransitionContextFromViewKey];
        iv.center = fromView.center;
        [fromView removeFromSuperview];
        [[transitionContext containerView] addSubview:iv];
        [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
            iv.frame = _smallRect;
        } completion:^(BOOL finished) {
            if (finished) {
                [iv removeFromSuperview];
                [transitionContext completeTransition:YES];
            }
        }];
    }
}

#pragma mark - private
- (void) scrollToBottom {
    if (self.dataSource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.dataSource.count-1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:NO];
    }
}

// tap image
- (void)showLargeImageWithPath:(NSString *)imgPath
                  withMessageF:(ADMessageFrame *)messageF {
    UIImage *image = [[ADMediaManager sharedManager] imageWithLocalPath:imgPath];
    if (image == nil) {
        NSLog(@"image is not existed");
        return;
    }
    ADPhotoBrowserViewController *photoVC = [[ADPhotoBrowserViewController alloc] initWithImage:image];
    self.presentImageView.image       = image;
    photoVC.transitioningDelegate     = self;
    photoVC.modalPresentationStyle    = UIModalPresentationCustom;
    [self presentViewController:photoVC animated:YES completion:nil];
}

- (void)timerInvalue {
    [_timer invalidate];
    _timer  = nil;
}

// 文件路径
- (NSString *)mediaPath:(NSString *)originPath {
    // 这里文件路径重新给，根据文件名字来拼接
    NSString *name = [[originPath lastPathComponent] stringByDeletingPathExtension];
    return [[ADRecordManager shareManager] receiveVoicePathWithFileKey:name];
}

- (void)showMenuViewController:(UIView *)showInView andIndexPath:(NSIndexPath *)indexPath message:(ADMessageModel *)messageModel {
    if (_copyMenuItem   == nil) {
        _copyMenuItem   = [[UIMenuItem alloc] initWithTitle:@"复制" action:@selector(copyMessage:)];
    }
    if (_deleteMenuItem == nil) {
        _deleteMenuItem = [[UIMenuItem alloc] initWithTitle:@"删除" action:@selector(deleteMessage:)];
    }
    if (_forwardMenuItem == nil) {
        _forwardMenuItem = [[UIMenuItem alloc] initWithTitle:@"转发" action:@selector(forwardMessage:)];
    }
    NSInteger currentTime = [ADMessageHelper currentMessageTime];
    NSInteger interval    = currentTime - messageModel.message.date;
    if (messageModel.isSender) {
        if ((interval/1000) < 5*60 && !(messageModel.message.deliveryState == ADMessageDeliveryState_Failure)) {
            if (_recallMenuItem == nil) {
                _recallMenuItem = [[UIMenuItem alloc] initWithTitle:@"撤回" action:@selector(recallMessage:)];
            }
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_recallMenuItem,_forwardMenuItem]];
        } else {
            [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
        }
    } else {
        [[UIMenuController sharedMenuController] setMenuItems:@[_copyMenuItem,_deleteMenuItem,_forwardMenuItem]];
    }
    [[UIMenuController sharedMenuController] setTargetRect:showInView.frame inView:showInView.superview ];
    [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
}

- (void)copyMessage:(UIMenuItem *)copyMenuItem {
    UIPasteboard *pasteboard  = [UIPasteboard generalPasteboard];
    ADMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    pasteboard.string         = messageF.model.message.content;
}

- (void)deleteMessage:(UIMenuItem *)deleteMenuItem {
    // 这里还应该把本地的消息附件删除
    ADMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    [self statusChanged:messageF];
}

- (void)recallMessage:(UIMenuItem *)recallMenuItem {
    // 这里应该发送消息撤回的网络请求
    ADMessageFrame * messageF = [self.dataSource objectAtIndex:_longIndexPath.row];
    [self.dataSource removeObject:messageF];
    self.message_id ++;
    ADMessageFrame *messageFrame = [ADMessageHelper createMessageFrame:TypeSystem messageId:[NSString stringWithFormat:@"%ld", self.message_id] content:@"你撤回了一条消息" path:nil fromName:@"发送者" fromHeadImage:@"" fileKey:nil isSender:YES receivedSenderByYourself:NO];
    [self.dataSource insertObject:messageFrame atIndex:_longIndexPath.row];
    [self.tableView reloadData];
}

- (void)statusChanged:(ADMessageFrame *)messageF {
    [self.dataSource removeObject:messageF];
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[_longIndexPath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)forwardMessage:(UIMenuItem *)forwardItem {
    NSLog(@"需要用到的数据库，等添加了数据库再做转发...");
}

#pragma mark - Getter and Setter
- (ADChatBoxViewController *) chatBoxVC {
    if (_chatBoxVC == nil) {
        _chatBoxVC = [[ADChatBoxViewController alloc] init];
        [_chatBoxVC.view setFrame:CGRectMake(0,ScreenHeight-HEIGHT_TABBAR, ScreenWidth, ScreenHeight)];
        _chatBoxVC.delegate = self;
    }
    return _chatBoxVC;
}

- (UITableView *)tableView {
    if (nil == _tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor redColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (NSMutableArray *)dataSource {
    if (_dataSource == nil) {
        _dataSource = [NSMutableArray array];
    }
    return _dataSource;
}

- (UIImageView *)presentImageView {
    if (!_presentImageView) {
        _presentImageView = [[UIImageView alloc] init];
    }
    return _presentImageView;
}

- (ADVoiceHud *)voiceHud {
    if (!_voiceHud) {
        _voiceHud = [[ADVoiceHud alloc] initWithFrame:CGRectMake(0, 0, 155, 155)];
        _voiceHud.hidden = YES;
        [self.view addSubview:_voiceHud];
        _voiceHud.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    }
    return _voiceHud;
}

- (NSTimer *)timer {
    if (!_timer) {
        _timer =[NSTimer scheduledTimerWithTimeInterval:0.3f target:self selector:@selector(progressChange) userInfo:nil repeats:YES];
    }
    return _timer;
}


@end
