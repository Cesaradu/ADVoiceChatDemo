//
//  ADChatMessageSyeCell.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "ADChatMessageBaseCell.h"

@class ADMessageFrame;

@interface ADChatMessageSyeCell : ADChatMessageBaseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
                       reusableId:(NSString *)ID;

@property (nonatomic, strong) ADMessageFrame *messageF;

@end
