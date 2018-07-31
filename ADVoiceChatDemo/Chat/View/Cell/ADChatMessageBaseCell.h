//
//  ADChatMessageBaseCell.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "BaseTableCell.h"
#import "ADMessageFrame.h"
#import "UIResponder+Helper.h"
#import "ADMessageConst.h"
#import "ADHeadImageView.h"

@class ADChatMessageBaseCell;
@protocol BaseCellDelegate <NSObject>

- (void)longPress:(UILongPressGestureRecognizer *)longRecognizer;

@optional
- (void)headImageClicked:(NSString *)eId;
- (void)reSendMessage:(ADChatMessageBaseCell *)baseCell;

@end

@interface ADChatMessageBaseCell : BaseTableCell

@property (nonatomic, weak) id <BaseCellDelegate> longPressDelegate;

// 消息模型
@property (nonatomic, strong) ADMessageFrame *modelFrame;
//昵称
@property (nonatomic, strong) UILabel *nameLabel;
// 头像
@property (nonatomic, strong) ADHeadImageView *headImageView;
// 内容气泡视图
@property (nonatomic, strong) UIImageView *bubbleView;
// 菊花视图所在的view
@property (nonatomic, strong) UIActivityIndicatorView *activityView;
// 重新发送
@property (nonatomic, strong) UIButton *retryButton;

@end

