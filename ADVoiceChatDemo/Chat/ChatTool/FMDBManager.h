//
//  FMDBManager.h
//  Happybird_keanxin
//
//  Created by Adu on 2018/7/26.
//  Copyright © 2018年 Oliver. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ADMessageModel.h"

@interface FMDBManager : NSObject

+ (instancetype)sharedFMDBManager;

#pragma mark - message表相关操作
//添加一条消息记录
- (void)addMessage:(ADMessageModel *)message;

//删除某条聊天记录
- (void)deleteMessage:(ADMessageModel *)message;

//更新某条消息（已读未读等）
- (void)updateMessage:(ADMessageModel *)message;

//获取所有消息记录
- (NSMutableArray *)getAllMessages;

//删除所有的聊天记录
- (void)deleteAllMessage;

@end

