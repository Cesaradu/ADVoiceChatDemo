//
//  ADChatBoxFaceView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatBoxFaceView.h"
#import "ADChatBoxMenuView.h"
#import "ADEmotionListView.h"
#import "ADFaceManager.h"

#define bottomViewH 36.0

@interface ADChatBoxFaceView () <UIScrollViewDelegate, ADChatBoxMenuDelegate>

@property (nonatomic, weak) ADEmotionListView *showingListView;
@property (nonatomic, strong) ADEmotionListView *emojiListView;
@property (nonatomic, strong) ADEmotionListView *custumListView;
@property (nonatomic, strong) ADEmotionListView *gifListView;
@property (nonatomic, weak) ADChatBoxMenuView *menuView;

@end

@implementation ADChatBoxFaceView

- (id) initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        ADChatBoxMenuView *menuView = [[ADChatBoxMenuView alloc] init];
        [menuView setDelegate:self];
        [self addSubview:menuView];
        _menuView = menuView;
        
        //        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //            self.custumListView.emotions = [ADFaceManager customEmotion];
        //        });
        self.custumListView.emotions = [ADFaceManager customEmotion];
        
        // 如果表情选中的时候需要动画或者其它操作,则在这里监听通知
    }
    return self;
}

#pragma mark - Private
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.menuView.width         = self.width;
    self.menuView.height        = bottomViewH;
    self.menuView.x             = 0;
    self.menuView.y             = self.height - self.menuView.height;
    
    self.showingListView.x      = self.showingListView.y = 0;
    self.showingListView.width  = self.width;
    self.showingListView.height = self.menuView.y;
}

#pragma mark - ADChatBoxMenuDelegate
- (void)emotionMenu:(ADChatBoxMenuView *)menu didSelectButton:(ADEmotionMenuButtonType)buttonType {
    [self.showingListView removeFromSuperview];
    switch (buttonType) {
        case ADEmotionMenuButtonTypeEmoji:
            [self addSubview:self.emojiListView];
            break;
        case ADEmotionMenuButtonTypeCustom:
            //            [self addSubview:self.custumListView];
            break;
        case ADEmotionMenuButtonTypeGif:
            //            [self addSubview:self.gifListView];
            break;
        default:
            break;
    }
    self.showingListView = [self.subviews lastObject];
    [self setNeedsLayout];
}


#pragma mark - Getter
- (ADEmotionListView *)emojiListView {
    if (!_emojiListView) {
        _emojiListView           = [[ADEmotionListView alloc] init];
        _emojiListView.emotions  = [ADFaceManager emojiEmotion];
    }
    return _emojiListView;
}

- (ADEmotionListView *)gifListView {
    if (!_gifListView) {
        _gifListView             = [[ADEmotionListView alloc] init];
    }
    return _gifListView;
}

- (ADEmotionListView *)custumListView {
    if (!_custumListView) {
        _custumListView          = [[ADEmotionListView alloc] init];
        _custumListView.emotions = [ADFaceManager customEmotion];
    }
    return _custumListView;
}

@end

