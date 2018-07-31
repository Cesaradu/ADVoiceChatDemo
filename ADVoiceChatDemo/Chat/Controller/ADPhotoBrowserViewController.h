//
//  ADPhotoBrowserViewController.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "BaseViewController.h"

@interface ADPhotoBrowserViewController : BaseViewController

@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong,) UIImageView *imageView;

- (instancetype)initWithImage:(UIImage *)image;

@end
