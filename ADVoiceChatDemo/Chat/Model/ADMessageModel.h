//
//  ADMessageModel.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADMessage.h"

@interface ADMessageModel : NSObject

@property (nonatomic, strong) NSString *message_id;

// 是否是发送者
@property (nonatomic, assign) BOOL isSender;

// 是否是群聊
//@property (nonatomic, assign) BOOL isChatGroup;

@property (nonatomic, strong) ADMessage *message;

// 包含voice，picture，video的路径;有大图时就是大图路径
// 不用这些路径了，只用里面的名字重新组成路径
@property (nonatomic, copy) NSString *mediaPath;

//头像
@property (nonatomic, strong) NSString *headImage;
//昵称
@property (nonatomic, strong) NSString *name;

@end

