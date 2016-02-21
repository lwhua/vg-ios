//
//  InputHelper.h
//  KKBusiness
//
//  Created by lulucas on 10/29/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface InputHelper : NSObject
/**
 *  在弹出的键盘上生成一个工具栏，点击可以收键盘
 *
 *  @return UIToolbar对象
 */
+ (UIToolbar *)createToolbar;
/**
 *  生成按钮
 *
 *  @param title       标题
 *  @param textColor   标题颜色
 *  @param bgColor     背景颜色
 *  @param bgColorHigh 背景高亮颜色
 *  @param fontSize    字体大小
 *  @param target      点击事件的目标
 *  @param action      点击事件的方法
 *  @param tag         tag值
 *  @param view        父view
 *  @param frame       frame
 *  @param bAL         是否需要支持autolayout
 *
 *  @return 按钮
 */
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
                  supportAotuLayout:(BOOL)bAL;

+ (UILabel *)createLabelWithFrame:(CGRect)rect
                            title:(NSString *)title
                        textColor:(UIColor *)textColor
                          bgColor:(UIColor *)bgColor
                         fontSize:(CGFloat)fontSize
                    textAlignment:(NSTextAlignment)textAlignment
                        addToView:(UIView *)view
                            bBold:(BOOL)bBold;

+ (CGSize)sizeWithText:(NSString *)text fontSize:(CGFloat)fontSize width:(CGFloat)width;
+ (CGSize)sizeWithAttributedText:(NSAttributedString *)text width:(CGFloat)width;


+ (NSMutableAttributedString *)attributedStringWithText:(NSString *)text
                                                   font:(UIFont *)font
                                                  color:(UIColor *)color
                                                  title:(NSString *)title
                                              titleFont:(UIFont *)titleFont
                                             titleColor:(UIColor *)titleColor;

//NSAttributedString
+ (NSAttributedString *)attributeStringWith:(NSString *)title
                                       font:(CGFloat)font
                                      color:(UIColor *)color;

//NSMutableParagraphStyle
+ (NSMutableParagraphStyle *)paraGraphStyle:(CGFloat)space
                                      align:(NSTextAlignment)align;


+ (NSString *)retureValidString:(NSString *)string;

+ (void)addStrikethroughStyleAttributeWithAttributedString:(NSMutableAttributedString *)attributedString range:(NSRange)range;

+ (NSString *)convertToJsonString:(id)source options:(BOOL)plain;
+ (id)jsonConvertToObject:(NSString *)source;


@end
