//
//  UITableView+HintMessage.m
//  YSBBusiness
//
//  Created by Sam Lau on 4/13/15.
//  Copyright (c) 2015 lu lucas. All rights reserved.
//

#import "UITableView+HintMessage.h"
#import <objc/runtime.h>

static const void* kHintMessageLabelKey = "HintMessageLabelKey";

@implementation UITableView (HintMessage)

- (UILabel*)hintMessageLabel
{
    UILabel* hintMessageLabel = objc_getAssociatedObject(self, kHintMessageLabelKey);
    if (!hintMessageLabel) {
        CGFloat cy = self.tableHeaderView == nil ? self.height / 2.0 : self.height / 2.0 + self.tableHeaderView.height / 2.0;
        CGFloat cx = 10.0f, cw = self.width - 2 * cx, ch = 18;
        hintMessageLabel = [InputHelper createLabelWithFrame:CGRectMake(cx, cy, cw, ch) title:@"" textColor:COLOR_646464 bgColor:COLOR_CLEAR fontSize:17.0f textAlignment:NSTextAlignmentCenter addToView:self bBold:NO];
        hintMessageLabel.numberOfLines = 0;
        objc_setAssociatedObject(self, kHintMessageLabelKey, hintMessageLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return hintMessageLabel;
}

- (void)showHintMessage:(NSString*)hintMessage
{
    UILabel* hintMessageLabel = [self hintMessageLabel];
    hintMessageLabel.text = hintMessage;
    CGRect rect = hintMessageLabel.frame;
    CGSize size = [InputHelper sizeWithText:hintMessageLabel.text fontSize:17.0f width:hintMessageLabel.width];
    rect.size.height = size.height;
    hintMessageLabel.frame = rect;
    hintMessageLabel.hidden = NO;
    
}

- (void)hideHintMessage
{
    UILabel* hintMessageLabel = [self hintMessageLabel];
    hintMessageLabel.hidden = YES;
}

@end
