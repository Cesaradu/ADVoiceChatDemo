//
//  ADEmotionButton.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADEmotionButton.h"

@implementation ADEmotionButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setup];
    }
    return self;
}


- (void)setup {
    self.titleLabel.font             = [UIFont systemFontOfSize:32.0];
    self.adjustsImageWhenHighlighted = NO;
}

- (void)setEmotion:(ADEmotion *)emotion {
    _emotion               = emotion;
    if (emotion.code) {
        [self setTitle:self.emotion.code.emoji forState:UIControlStateNormal];
    } else if (emotion.face_name) {
        [self setImage:[UIImage imageNamed:self.emotion.face_name] forState:UIControlStateNormal];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
