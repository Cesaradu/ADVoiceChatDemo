//
//  FMDBManager.m
//  Happybird_keanxin
//
//  Created by Adu on 2018/7/26.
//  Copyright © 2018年 Oliver. All rights reserved.
//

#import "FMDBManager.h"
#import "ADMessageFrame.h"

@interface FMDBManager ()

@property (nonatomic, strong) FMDatabase *fmdb;

@end

@implementation FMDBManager

+ (instancetype)sharedFMDBManager {
    static FMDBManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[FMDBManager alloc] init];
        [sharedManager initDataBase];
    });
    return sharedManager;
}

//初始化数据库
- (void)initDataBase {
    //获得Documents目录路径
    NSString *documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    //文件路径
    NSString *filePath = [documentsPath stringByAppendingPathComponent:@"wechat.sqlite"];
    self.fmdb = [FMDatabase databaseWithPath:filePath];
    [self.fmdb open];
    //初始化聊天记录表
    NSString *messageSql = @"CREATE TABLE IF NOT EXISTS 'message' ('id' INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL , 'message_id' VARCHAR(255), 'is_sender' VARCHAR(255),'message' BLOB,'mediapath' TEXT,'headimage' TEXT,'name' VARCHAR(255))";
    [self.fmdb executeUpdate:messageSql];
    [self.fmdb close];
}

//给学生添加一条聊天记录
- (void)addMessage:(ADMessageModel *)message {
    [self.fmdb open];
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:message.message];
    [self.fmdb executeUpdate:@"INSERT INTO message(message_id, is_sender, message, mediapath, headimage, name)VALUES(?, ?, ?, ?, ?, ?)",message.message_id, [NSString stringWithFormat:@"%d", message.isSender], messageData, message.mediaPath, message.headImage, message.name];
    [self.fmdb close];
}

//获取所有聊天记录
- (NSMutableArray *)getAllMessages {
    [self.fmdb open];
    NSMutableArray *messageArray = [NSMutableArray new];
    FMResultSet *results = [self.fmdb executeQuery:@"SELECT * FROM message"];
    while ([results next]) {
        ADMessageModel *model = [[ADMessageModel alloc] init];
        model.isSender = [[results stringForColumn:@"is_sender"] boolValue];
        model.mediaPath = [results stringForColumn:@"mediapath"];
        model.headImage = [results stringForColumn:@"headimage"];
        model.name = [results stringForColumn:@"name"];
        model.message_id = [results stringForColumn:@"message_id"];
        NSData *messageData = [results dataForColumn:@"message"];
        ADMessage *message = [NSKeyedUnarchiver unarchiveObjectWithData:messageData];
        model.message = message;
        
        ADMessageFrame *messageFrame = [[ADMessageFrame alloc] init];
        messageFrame.model = model;
        [messageArray addObject:messageFrame];
    }
    return messageArray;
}

//更新某个孩子的某条消息（更新已读未读、消息是否发送等状态）
- (void)updateMessage:(ADMessageModel *)message {
    [self.fmdb open];
    NSData *messageData = [NSKeyedArchiver archivedDataWithRootObject:message.message];
    [self.fmdb executeUpdate:@"UPDATE 'message' SET message = ? WHERE message_id = ?", messageData, message.message_id];
    [self.fmdb close];
}

//删除某个孩子的某条聊天记录
- (void)deleteMessage:(ADMessageModel *)message {
    [self.fmdb open];
    [self.fmdb executeUpdate:@"DELETE FROM message WHERE message_id = ?", message.message_id];
    [self.fmdb close];
}


- (void)deleteAllMessage {
    
}


@end

