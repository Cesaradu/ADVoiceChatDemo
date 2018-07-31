//
//  ADFileButton.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ADMessageModel;

@interface ADFileButton : UIButton

@property (nonatomic, strong) ADMessageModel *messageModel;
@property (nonatomic, strong) UILabel *identLabel;
@property (nonatomic, strong) UIProgressView *progressView;

@end
