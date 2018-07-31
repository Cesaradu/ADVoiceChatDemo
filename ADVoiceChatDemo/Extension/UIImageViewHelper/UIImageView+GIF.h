//
//  UIImageView+GIF.h
//  BaseFramework
//
//  Created by hztuen on 17/3/20.
//  Copyright © 2017年 Cesar. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (GIF)

//帧视图合集
@property (nonatomic,strong)NSArray *image_array;

- (void)showGifImageWithData:(NSData *)data;
- (void)showGifImageWithURL:(NSURL *)url;

@end
