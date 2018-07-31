//
//  ADDocumentViewController.h
//  ADVoiceChatDemo
//
//  Created by Adu on 2018/7/20.
//  Copyright © 2018年 Adu. All rights reserved.
//

#import "BaseViewController.h"

@protocol ADDocumentDelegate <NSObject>

- (void)selectedFileName:(NSString *)fileName;

@end

@interface ADDocumentViewController : BaseViewController

@property (nonatomic, weak) id <ADDocumentDelegate> delegate;

@end
