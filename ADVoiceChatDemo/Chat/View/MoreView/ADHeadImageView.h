//
//  ADHeadImageView.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ADHeadImageView : UIView

@property (nonatomic, weak) UIImageView *imageView;

- (void)setColor:(UIColor *)color bording:(CGFloat)bording;


@end
