//
//  ADEmotionPageView.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADEmotion.h"

#define ADEmotionMaxRows 3
#define ADEmotionMaxCols 7
#define ADEmotionPageSize ((ADEmotionMaxRows * ADEmotionMaxCols) - 1)

@interface ADEmotionPageView : UIView

@property (nonatomic, strong) NSArray *emotions;

@end
