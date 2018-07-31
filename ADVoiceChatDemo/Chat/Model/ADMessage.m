//
//  ADMessage.m
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADMessage.h"

@interface ADMessage () <NSCoding>

@end

@implementation ADMessage

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.senderName forKey:@"senderName"];
    [aCoder encodeObject:self.from forKey:@"from"];
    [aCoder encodeObject:self.to forKey:@"to"];
    [aCoder encodeObject:self.messageId forKey:@"messageId"];
    [aCoder encodeInteger:self.deliveryState forKey:@"deliveryState"];
    [aCoder encodeInteger:self.date forKey:@"date"];
    [aCoder encodeObject:self.localMsgId forKey:@"localMsgId"];
    [aCoder encodeObject:self.content forKey:@"content"];
    [aCoder encodeObject:self.fileKey forKey:@"fileKey"];
    [aCoder encodeObject:self.type forKey:@"type"];
    [aCoder encodeObject:self.lnk forKey:@"lnk"];
    [aCoder encodeInteger:self.status forKey:@"status"];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (self) {
        self.senderName = [aDecoder decodeObjectForKey:@"senderName"];
        self.from = [aDecoder decodeObjectForKey:@"from"];
        self.to = [aDecoder decodeObjectForKey:@"to"];
        self.messageId = [aDecoder decodeObjectForKey:@"messageId"];
        self.deliveryState = (MessageDeliveryState)[aDecoder decodeIntegerForKey:@"deliveryState"];
        self.date = [aDecoder decodeIntegerForKey:@"date"];
        self.localMsgId = [aDecoder decodeObjectForKey:@"localMsgId"];
        self.content = [aDecoder decodeObjectForKey:@"content"];
        self.fileKey = [aDecoder decodeObjectForKey:@"fileKey"];
        self.type = [aDecoder decodeObjectForKey:@"type"];
        self.lnk = [aDecoder decodeObjectForKey:@"lnk"];
        self.status = (ADMessageStatus)[aDecoder decodeIntegerForKey:@"status"];
    }
    return self;
}

@end

