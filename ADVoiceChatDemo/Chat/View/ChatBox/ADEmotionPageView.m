//
//  ADEmotionPageView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADEmotionPageView.h"
#import "ADMessageConst.h"
#import "ADEmotion.h"
#import "ADEmotionButton.h"
#import "ADFaceManager.h"

@interface ADEmotionPageView ()

@property (nonatomic, weak) UIButton *deleteBtn;

@end

@implementation ADEmotionPageView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"emotion_delete"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:deleteBtn];
        self.deleteBtn       =  deleteBtn;
    }
    return self;
}

#pragma mark - Private
- (void)deleteBtnClicked:(UIButton *)deleteBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:ADEmotionDidDeleteNotification object:nil];// 通知出去
}

- (void)setEmotions:(NSArray *)emotions {
    _emotions                   = emotions;
    NSUInteger count            = emotions.count;
    for (int i = 0; i < count; i ++) {
        ADEmotionButton *button = [[ADEmotionButton alloc] init];
        [self addSubview:button];
        button.emotion          = emotions[i];
        [button addTarget:self action:@selector(emotionBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGFloat inset            = 15;
    NSUInteger count         = self.emotions.count;
    CGFloat btnW             = (self.width - 2*inset)/ADEmotionMaxCols;
    CGFloat btnH             = (self.height - 2*inset)/ADEmotionMaxRows;
    for (int i = 0; i < count; i ++) {
        ADEmotionButton *btn = self.subviews[i + 1];//因为已经加了一个deleteBtn了
        btn.width            = btnW;
        btn.height           = btnH;
        btn.x                = inset + (i % ADEmotionMaxCols)*btnW;
        btn.y                = inset + (i / ADEmotionMaxCols)*btnH;
    }
    self.deleteBtn.width     = btnW;
    self.deleteBtn.height    = btnH;
    self.deleteBtn.x         = inset + (count % ADEmotionMaxCols)*btnW;
    self.deleteBtn.y         = inset + (count / ADEmotionMaxCols)*btnH;
}

- (void)emotionBtnClicked:(ADEmotionButton *)button {
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
    userInfo[ADSelectEmotionKey]  = button.emotion;
    [[NSNotificationCenter defaultCenter] postNotificationName:ADEmotionDidSelectNotification object:nil userInfo:userInfo];
}



@end
