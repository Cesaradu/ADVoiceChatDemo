//
//  ADAudioView.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADAudioView.h"
#import "ADRecordManager.h"
#import <AVFoundation/AVFoundation.h>
#import "ADMessageHelper.h"

@interface ADAudioView () <AVAudioPlayerDelegate, ADRecordManagerDelegate>
{
    UILabel * _nameLabel;
    UILabel * _endTimeLabel;
    AVAudioPlayer *_player;
    NSTimer * _timer;
    UIProgressView * _progressV;
    UIButton * _playBtn;
}

@end

@implementation ADAudioView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setSubView:frame];
    }
    return self;
}

- (void)setSubView:(CGRect)frame {
    UIImageView *imageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"iconfont-luyin"]];
    imageV.frame = CGRectMake(150, 105, 99, 143);
    imageV.centerX = frame.size.width*0.5;
    [self addSubview:imageV];
    
    UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, imageV.bottom+27, 250, 20)];
    nameLabel.textAlignment = NSTextAlignmentCenter;
    nameLabel.lineBreakMode = NSLineBreakByTruncatingMiddle;
    nameLabel.centerX = frame.size.width*0.5;
    nameLabel.font    = [UIFont systemFontOfSize:15.0];
    nameLabel.textColor = ADRGB(0x535f62);
    nameLabel.text    = _audioName;
    [self addSubview:nameLabel];
    _nameLabel = nameLabel;
    
    UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kaishianniu"] forState:UIControlStateNormal];
    playBtn.frame = CGRectMake(25,nameLabel.bottom+200, 50, 50);
    [self addSubview:playBtn];
    [playBtn addTarget:self action:@selector(beginPlay:) forControlEvents:UIControlEventTouchUpInside];
    _playBtn = playBtn;
    /*
     UISlider * slider = [[UISlider alloc] initWithFrame:CGRectMake(playBtn.right+16, playBtn.top, frame.size.width-playBtn.right-16-25, 10)];
     slider.centerY = playBtn.centerY;
     slider.thumbTintColor = IColor(13, 103, 135);
     slider.minimumTrackTintColor = IColor(13, 103, 135);
     slider.value = 0.5;
     [self addSubview:slider];
     */
    UIProgressView *progressV = [[UIProgressView alloc] initWithFrame:CGRectMake(playBtn.right+16, playBtn.top, frame.size.width-playBtn.right-16-25, 10)];
    progressV.centerY = playBtn.centerY;
    progressV.progressTintColor =  RGBA_COLOR(13, 103, 135, 1);
    [self addSubview:progressV];
    _progressV = progressV;
    
    UILabel * endTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(progressV.right-100, progressV.bottom+14, 100, 20)];
    endTimeLabel.textAlignment = NSTextAlignmentRight;
    endTimeLabel.font = [UIFont systemFontOfSize:14.0];
    endTimeLabel.textColor = ADRGB(0x535f62);
    [self addSubview:endTimeLabel];
    _endTimeLabel = endTimeLabel;
    
}

- (void)setAudioName:(NSString *)audioName {
    _audioName = audioName;
    _nameLabel.text = audioName;
}

- (void)setAudioPath:(NSString *)audioPath {
    _audioPath = audioPath;
    NSUInteger durataion = [[ADRecordManager shareManager] durationWithAudio:[NSURL fileURLWithPath:audioPath]];
    _endTimeLabel.text = [ADMessageHelper timeDurationFormatter:durataion];
}

- (void)beginPlay:(UIButton *)playBtn {
    ADRecordManager *manager = [ADRecordManager shareManager];
    if (manager.player == nil) {
        [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhanting"] forState:UIControlStateNormal];
        manager.playDelegate = self;
        [manager startPlayRecorder:_audioPath];
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self
                                                selector:@selector(playProgress)
                                                userInfo:nil repeats:YES];
    } else if ([manager.player isPlaying]) {
        [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kaishianniu"] forState:UIControlStateNormal];
        [manager pause];
        [_timer setFireDate:[NSDate distantFuture]];
    } else {
        [playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-zhanting"] forState:UIControlStateNormal];
        [manager.player play];
        [_timer setFireDate:[NSDate date]];
    }
    
}

- (void)playProgress {
    ADRecordManager *manager = [ADRecordManager shareManager];
    _progressV.progress = [[manager player] currentTime]/[[manager player]duration];
}

- (void)timerInvalid {
    [_timer invalidate];
    _timer = nil;
}

#pragma mark - delegate
// 释放
- (void)voiceDidPlayFinished {
    [self timerInvalid];
    [[ADRecordManager shareManager] stopPlayRecorder:_audioPath];
    ADRecordManager *manager = [ADRecordManager shareManager];
    [manager stopPlayRecorder:_audioPath];
    manager.playDelegate = nil;
    [_playBtn setBackgroundImage:[UIImage imageNamed:@"iconfont-kaishianniu"] forState:UIControlStateNormal];
}

- (void)releaseTimer {
    [self timerInvalid];
}

- (void)dealloc {
    ADRecordManager *manager = [ADRecordManager shareManager];
    [manager stopPlayRecorder:_audioPath];
    manager.playDelegate = nil;
    [self timerInvalid];
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
