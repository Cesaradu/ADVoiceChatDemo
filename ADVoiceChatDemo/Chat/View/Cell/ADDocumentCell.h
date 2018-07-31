//
//  ADDocumentCell.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "BaseTableCell.h"

@protocol ADDocumentCellDelegate <NSObject>

- (void)selectBtnClicked:(id)sender;

@end

@interface ADDocumentCell : BaseTableCell

@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *filePath;

@property (nonatomic, weak) id <ADDocumentCellDelegate> delegate;

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, weak) UIButton *selectBtn;

@end
