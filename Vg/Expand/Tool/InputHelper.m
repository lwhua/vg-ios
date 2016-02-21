//
//  InputHelper.m
//  KKBusiness
//
//  Created by lulucas on 10/29/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import "InputHelper.h"
#import "Macro.h"
#import "ColorHelper.h"

@implementation InputHelper

//+ (UIToolbar *)createToolbar
//{
//    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 44)];
//    if (NSFoundationVersionNumber >= NSFoundationVersionNumber_iOS_7_0) {
//        toolBar.translucent = NO;
//        toolBar.barTintColor = COLOR_B3;
//    } else {
//        [[UIToolbar appearance] setBackgroundImage:[ColorHelper imageWithColor:[UIColor colorWithRed:52/255.f green:152/255.f blue:219/255.f alpha:1.0f] size:CGSizeMake(1, 44)] forToolbarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
//        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new]
//                                                forState:UIControlStateNormal
//                                              barMetrics:UIBarMetricsDefault];
//    }
//    
//    
//    UIBarButtonItem *nextButton = [[UIBarButtonItem alloc] initWithTitle:@""
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:nil];
//    UIBarButtonItem *prevButton = [[UIBarButtonItem alloc] initWithTitle:@""
//                                                                   style:UIBarButtonItemStylePlain
//                                                                  target:self
//                                                                  action:nil];
//    UIBarButtonItem *space = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
//    UIButton *doneBtn = [InputHelper createButtonWithTitle:@"完成"
//                                                 textColor:kMainColor
//                                                   bgColor:COLOR_B3
//                                               bgColorHigh:[UIColor lightGrayColor]
//                                                  fontSize:14
//                                                    target:self
//                                                    action:@selector(textFieldDone)
//                                                       tag:kButtonTag
//                                                 addToView:nil
//                                                     frame:CGRectMake(0, 0, 44.0f, 44.0f)
//                                         supportAotuLayout:NO];
//    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
//    toolBar.items = @[prevButton, nextButton, space, done];
//    
//    return toolBar;
//}

+ (void)textFieldDone
{
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
}

+ (UIButton *)createButtonWithTitle:(NSString *)title
                          textColor:(UIColor *)textColor
                            bgColor:(UIColor *)bgColor
                        bgColorHigh:(UIColor *)bgColorHigh
                           fontSize:(CGFloat)fontSize
                             target:(id)target
                             action:(SEL)action
                                tag:(NSInteger)tag
                          addToView:(UIView *)view
                              frame:(CGRect)frame
                         supportAotuLayout:(BOOL)bAL

{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = !bAL;
    btn.frame = frame;
    [btn setTitle:title forState:UIControlStateNormal];
    btn.backgroundColor = bgColor;
    btn.tag = tag;
    [btn setBackgroundImage:[ColorHelper imageWithColor:bgColorHigh size:CGSizeMake(1, 1)] forState:UIControlStateHighlighted];
    [btn setTitleColor:textColor forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:btn];
    return btn;
}

+ (UILabel *)createLabelWithFrame:(CGRect)rect
                            title:(NSString *)title
                        textColor:(UIColor *)textColor
                          bgColor:(UIColor *)bgColor
                         fontSize:(CGFloat)fontSize
                    textAlignment:(NSTextAlignment)textAlignment
                        addToView:(UIView *)view
                            bBold:(BOOL)bBold
{
    UILabel *label = [[UILabel alloc] initWithFrame:rect];
    label.backgroundColor = bgColor;
    if (bBold) {
        label.font = [UIFont boldSystemFontOfSize:fontSize];
    } else {
        label.font = [UIFont systemFontOfSize:fontSize];
    }
    
    label.textColor = textColor;
    label.text = title;
    label.textAlignment = textAlignment;
    [view addSubview:label];
    if (CGRectEqualToRect(rect, CGRectZero)
        || CGRectEqualToRect(rect, CGRectNull)) {
        [label sizeToFit];
    }
    return label;
}

+ (CGSize)sizeWithText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width
{
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:fontSize], NSFontAttributeName,nil];
    CGSize size = CGSizeMake(width, 20000.0f);
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    return size;
}

+ (CGSize)sizeWithAttributedText:(NSAttributedString *)text width:(CGFloat)width
{
    CGSize size = CGSizeMake(width, 20000.0f);
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil].size;
    return size;
}

+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
                                                   font:(UIFont *)font
                                                  color:(UIColor *)color
                                                  title:(NSString *)title
                                              titleFont:(UIFont *)titleFont
                                             titleColor:(UIColor *)titleColor
{
    NSMutableAttributedString *attriString = [[NSMutableAttributedString alloc] initWithString:text];
    
    
    
    [attriString addAttribute:NSFontAttributeName
                        value:font
                        range:NSMakeRange(0, text.length)];
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:color
                        range:NSMakeRange(0, text.length)];
    
    [attriString addAttribute:NSFontAttributeName
                        value:titleFont
                        range:[text rangeOfString:title]];
    
    [attriString addAttribute:NSForegroundColorAttributeName
                        value:titleColor
                        range:[text rangeOfString:title]];
    
    
    return attriString;
}

//NSAttributedString
+ (NSAttributedString *)attributeStringWith:(NSString *)title
                                       font:(CGFloat)font
                                      color:(UIColor *)color {
    return [[NSAttributedString alloc] initWithString:title
                                           attributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIFont systemFontOfSize:font],
                                                       NSFontAttributeName,
                                                       color,
                                                       NSForegroundColorAttributeName, nil]];
    
    
}

//NSMutableParagraphStyle
+ (NSMutableParagraphStyle *)paraGraphStyle:(CGFloat)space
                                      align:(NSTextAlignment)align {
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = space;
    paragraphStyle.alignment = align;
    
    return paragraphStyle;
}

+ (NSString *)retureValidString:(NSString *)string
{
    if (![string isKindOfClass:[NSString class]]) {
        return @"";
    }
    
    if (string.length == 0) {
        return @"";
    }
    
    return string;
}

+ (void)addStrikethroughStyleAttributeWithAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range
{
    [attributedString addAttribute:NSStrikethroughStyleAttributeName
                             value:[NSNumber numberWithInteger:NSUnderlineStyleSingle]
                             range:range];
}

+ (NSString *)convertToJsonString:(id)source options:(BOOL)plain
{
    if ([NSJSONSerialization isValidJSONObject:source]) {
        NSError *error;
        NSData *data = [NSJSONSerialization dataWithJSONObject:source options:plain?kNilOptions:NSJSONWritingPrettyPrinted error:&error];
        if (!error) {
            return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        }
    }
    return nil;
}

+ (id)jsonConvertToObject:(NSString *)source
{
    NSData *data = [source dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if (!error) {
        return object;
    }
    return nil;
}

@end
