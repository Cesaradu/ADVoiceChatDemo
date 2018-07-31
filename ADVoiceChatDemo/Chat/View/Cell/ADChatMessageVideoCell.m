//
//  ADChatMessageVideoCell.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatMessageVideoCell.h"
#import "ADMessageModel.h"
#import "ADMessage.h"
#import "ADVideoManager.h"
#import "ADMediaManager.h"
#import "ZacharyPlayManager.h"
#import "ADAVPlayer.h"
#import "ADFileTool.h"

@interface ADChatMessageVideoCell ()

@property (nonatomic, strong) UIButton *imageBtn;
@property (nonatomic, strong) UIButton *topBtn;

@end

@implementation ADChatMessageVideoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.imageBtn];
        [self.imageBtn addSubview:self.topBtn];
    }
    return self;
}

- (void)setModelFrame:(ADMessageFrame *)modelFrame {
    [super setModelFrame:modelFrame];
    ADMediaManager *manager = [ADMediaManager sharedManager];
    
    NSString *path          = [[ADVideoManager shareManager] receiveVideoPathWithFileKey:[modelFrame.model.mediaPath.lastPathComponent stringByDeletingPathExtension]];
    UIImage *videoArrowImage = [manager videoConverPhotoWithVideoPath:path size:modelFrame.picViewF.size isSender:modelFrame.model.isSender];
    
    self.imageBtn.frame = modelFrame.picViewF;
    self.bubbleView.userInteractionEnabled = videoArrowImage != nil;
    self.bubbleView.image = nil;
    [self.imageBtn setImage:videoArrowImage forState:UIControlStateNormal];
    self.topBtn.frame = CGRectMake(0, 0, _imageBtn.width, _imageBtn.height);
}

- (void)imageBtnClick:(UIButton *)btn {
    __block NSString *path = [[ADVideoManager shareManager] videoPathForMP4:self.modelFrame.model.mediaPath];
    [self videoPlay:path];
}

- (void)videoPlay:(NSString *)path {
    ADAVPlayer *player = [[ADAVPlayer alloc] initWithPlayerURL:[NSURL fileURLWithPath:path]];
    [player presentFromVideoView:self.imageBtn toContainer:[UIApplication sharedApplication].keyWindow.rootViewController.view animated:YES completion:nil];
}

#pragma mark - videoPlay
- (void)firstPlay {
    __block NSString *path = [[ADVideoManager shareManager] videoPathForMP4:self.modelFrame.model.mediaPath];
    if ([ADFileTool fileExistsAtPath:path]) {
        [self reloadStart];
        _topBtn.hidden = YES;
    }
}

- (void)reloadStart {
    __weak typeof(self) weakSelf=self;
    NSString *path = [[ADVideoManager shareManager] videoPathForMP4:self.modelFrame.model.mediaPath];
    [[ZacharyPlayManager sharedInstance] startWithLocalPath:path WithVideoBlock:^(UIImage *imageData, NSString *filePath,CGImageRef tpImage) {
        if ([filePath isEqualToString:path]) {
            [self.imageBtn setImage:imageData forState:UIControlStateNormal];
        }
    }];
    
    [[ZacharyPlayManager sharedInstance] reloadVideo:^(NSString *filePath) {
        MAIN(^{
            if ([filePath isEqualToString:path]) {
                [weakSelf reloadStart];
            }
        });
    } withFile:path];
}

- (void)stopVideo {
    _topBtn.hidden = NO;
    [[ZacharyPlayManager sharedInstance] cancelVideo:[[ADVideoManager shareManager] videoPathForMP4:self.modelFrame.model.mediaPath]];
}

- (void)dealloc {
    [[ZacharyPlayManager sharedInstance] cancelAllVideo];
}

#pragma mark - Getter
- (UIButton *)imageBtn {
    if (nil == _imageBtn) {
        _imageBtn = [[UIButton alloc] init];
        [_imageBtn addTarget:self action:@selector(imageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        _imageBtn.layer.masksToBounds = YES;
        _imageBtn.layer.cornerRadius = 5;
        _imageBtn.clipsToBounds = YES;
    }
    return _imageBtn;
}

- (UIButton *)topBtn {
    if (!_topBtn) {
        _topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_topBtn addTarget:self action:@selector(firstPlay) forControlEvents:UIControlEventTouchUpInside];
        _topBtn.layer.masksToBounds = YES;
        _topBtn.layer.cornerRadius = 5;
    }
    return _topBtn;
}

@end
