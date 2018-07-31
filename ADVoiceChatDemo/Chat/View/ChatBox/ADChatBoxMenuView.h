//
//  ADChatBoxMenuView.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    ADEmotionMenuButtonTypeEmoji = 100,
    ADEmotionMenuButtonTypeCustom,
    ADEmotionMenuButtonTypeGif
    
} ADEmotionMenuButtonType;

@class ADChatBoxMenuView;

@protocol ADChatBoxMenuDelegate <NSObject>

@optional
- (void)emotionMenu:(ADChatBoxMenuView *)menu
    didSelectButton:(ADEmotionMenuButtonType)buttonType;

@end

@interface ADChatBoxMenuView : UIView

@property (nonatomic, weak)id <ADChatBoxMenuDelegate> delegate;


@end

