//
//  ADChatBoxViewController.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "BaseViewController.h"
#import "ADChatBoxViewControllerDelegate.h"
#import "ADChatBox.h"
#import "ADRecordManager.h"

@interface ADChatBoxViewController : BaseViewController

@property(nonatomic, weak) id <ADChatBoxViewControllerDelegate> delegate;

@property (nonatomic, strong) ADChatBox *chatBox;

@end
