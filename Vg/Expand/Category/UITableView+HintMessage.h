//
//  UITableView+HintMessage.h
//  YSBBusiness
//
//  Created by Sam Lau on 4/13/15.
//  Copyright (c) 2015 lu lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (HintMessage)
- (UILabel*)hintMessageLabel;
- (void)showHintMessage:(NSString*)hintMessage; // 显示table view没有数据时的信息
- (void)hideHintMessage;                        // 隐藏提示信息
@end
