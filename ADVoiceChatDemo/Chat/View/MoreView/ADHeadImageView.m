//
//  ADHeadImageView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADHeadImageView.h"

@interface ADHeadImageView ()

@property (nonatomic, assign) CGFloat bordering;

@end

@implementation ADHeadImageView

- (instancetype)init {
    if (self = [super init]) {
        [self imageView];
        self.layer.masksToBounds  = YES;
        self.backgroundColor      = ADRGB(0xf0f0f0);
        //        self.bordering            = 4;
        self.bordering            = 0;
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    [super setFrame:frame];
}

- (void)layoutSubviews {
    self.layer.cornerRadius = self.frame.size.width*0.5;
    self.imageView.width = self.frame.size.width - _bordering;
    self.imageView.height = self.frame.size.height - _bordering;
    self.imageView.layer.cornerRadius = self.imageView.width*0.5;
    
    self.imageView.centerX = self.width*0.5;
    self.imageView.centerY = self.height*0.5;
}

- (void)setColor:(UIColor *)color bording:(CGFloat)bord {
    self.backgroundColor = color;
    self.bordering       = bord;
}

- (UIImageView *)imageView {
    if (nil == _imageView) {
        UIImageView *imageV = [[UIImageView alloc] init];
        imageV.layer.masksToBounds = YES;
        [self addSubview:imageV];
        _imageView = imageV;
    }
    return _imageView;
}


@end
