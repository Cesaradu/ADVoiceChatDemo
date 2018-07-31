//
//  ADChatBoxMoreView.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADChatBoxMoreViewItem.h"

typedef NS_ENUM(NSInteger, ADChatBoxItem){
    ADChatBoxItemAlbum = 0,   // Album
    ADChatBoxItemCamera,      // Camera
    ADChatBoxItemVideo,       // Video
    ADChatBoxItemDoc          // pdf
};

@class ADChatBoxMoreView;
@protocol ADChatBoxMoreViewDelegate <NSObject>
/**
 *  点击更多的类型
 *
 *  @param chatBoxMoreView ICChatBoxMoreView
 *  @param itemType        类型
 */
- (void)chatBoxMoreView:(ADChatBoxMoreView *)chatBoxMoreView didSelectItem:(ADChatBoxItem)itemType;

@end

@interface ADChatBoxMoreView : UIView

@property (nonatomic, weak) id <ADChatBoxMoreViewDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *items;

@end
