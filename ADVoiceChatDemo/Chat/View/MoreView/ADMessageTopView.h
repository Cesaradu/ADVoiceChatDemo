//
//  ADMessageTopView.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADMessageTopView : UIView

- (void)messageSendName:(NSString *)name
               isSender:(BOOL)isSender
                   date:(NSInteger)date;

@end
