//
//  ADChatBoxMenuView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatBoxMenuView.h"
#import "ADEmotionMenuButton.h"
#import "ADMessageConst.h"

@interface ADChatBoxMenuView ()

@property (nonatomic, weak) UIScrollView *scrollView;
@property (nonatomic, weak) UIButton     *sendBtn;

@property (nonatomic, weak) ADEmotionMenuButton *selectedBtn;

@end

@implementation ADChatBoxMenuView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        [self setupBtn:[@"0x1f603" emoji] buttonType:ADEmotionMenuButtonTypeEmoji];
        //        [self setupBtn:@"Custom" buttonType:ADEmotionMenuButtonTypeCustom];
        //        [self setupBtn:@"Gif" buttonType:ICEmotionMenuButtonTypeGif];
    }
    return self;
}

/**
 *  创建按钮
 *
 *  @param title      按钮文字
 *  @param buttonType 类型
 *
 *  @return 按钮
 */
- (ADEmotionMenuButton *)setupBtn:(NSString *)title
                       buttonType:(ADEmotionMenuButtonType)buttonType {
    ADEmotionMenuButton *btn = [[ADEmotionMenuButton alloc] init];
    [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchDown];
    btn.tag                  = buttonType; // 不要把0作为tag值
    
    if ([title isEqualToString:@"Custom"]) {
        [btn setImage:[UIImage imageNamed:@"[吓]"] forState:UIControlStateNormal];
    } else {
        [btn setTitle:title forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:26.5];
    }
    [self.scrollView addSubview:btn];
    [btn setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]]forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageWithColor:RGBA_COLOR(241, 241, 244, 1)] forState:UIControlStateSelected];
    return btn;
}

#pragma mark - Private
- (void)sendBtnClicked:(UIButton *)sendBtn {
    [[NSNotificationCenter defaultCenter] postNotificationName:ADEmotionDidSendNotification object:nil];
}

- (void)btnClicked:(ADEmotionMenuButton *)button {
    self.selectedBtn.selected = NO;
    button.selected           = YES;
    self.selectedBtn         = button;
    if ([self.delegate respondsToSelector
         :@selector(emotionMenu:didSelectButton:)]) {
        [self.delegate emotionMenu:self
                   didSelectButton:(int)button.tag];
    }
}

- (void)setDelegate:(id<ADChatBoxMenuDelegate>)delegate {
    _delegate = delegate;
    
    [self btnClicked:(ADEmotionMenuButton *)[self viewWithTag:ADEmotionMenuButtonTypeEmoji]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSUInteger count      = self.scrollView.subviews.count;
    //    CGFloat btnW          = self.width/(count+1);
    CGFloat btnW          = 60;
    self.scrollView.frame = CGRectMake(0, 0, self.width-btnW, self.height);
    self.sendBtn.frame    = CGRectMake(self.width-btnW, 0, btnW, self.height);
    CGFloat btnH          = self.height;
    for (int i = 0; i < count; i ++) {
        ADEmotionMenuButton *btn = self.scrollView.subviews[i];
        btn.y                    = 0;
        btn.width                = (int)btnW;// 去除小缝隙
        btn.height               = btnH;
        btn.x                    = (int)btnW * i;
    }
}

#pragma mark - Getter
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] init];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [scrollView setScrollsToTop:NO];
        [self addSubview:scrollView];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        _scrollView              = scrollView;
    }
    return _scrollView;
}

- (UIButton *)sendBtn {
    if (!_sendBtn) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:@"发送" forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [btn setBackgroundColor:[UIColor colorWithHexString:MainColor alpha:1.0]];
        [self addSubview:btn];
        _sendBtn = btn;
        [btn addTarget:self action:@selector(sendBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _sendBtn;
}


/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */

@end

