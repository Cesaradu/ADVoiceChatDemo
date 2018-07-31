//
//  ADAudioView.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADAudioView : UIView

@property (nonatomic, copy) NSString *audioName;
@property (nonatomic, copy) NSString *audioPath;

- (void)releaseTimer;

@end
