//
//  UIButton+addtion.m
//  YSBBusiness
//
//  Created by jackyshan on 11/18/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import "UIButton+addtion.h"
#import "UIView+FrameHelper.h"

@implementation UIButton (addtion)

- (void)setTitle:(NSString *)title
{
    [self setTitle:title forState:UIControlStateNormal];
}

- (void)setAttributedTitle:(NSAttributedString *)title
{
    [self setAttributedTitle:title forState:UIControlStateNormal];
}

- (void)setTitleColor:(UIColor *)color
{
    [self setTitleColor:color forState:UIControlStateNormal];
}

- (void)setImage:(UIImage *)image
{
    [self setImage:image forState:UIControlStateNormal];
}

- (void)setBackgroundImage:(UIImage *)image
{
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

- (void)setCenterImage
{
    self.titleEdgeInsets = UIEdgeInsetsMake(40.0, -self.imageView.image.size.width, 0.0, 0.0);
    self.imageEdgeInsets = UIEdgeInsetsMake(-20.0, 0.0, 0.0, -self.titleLabel.width);
}

- (void)addTarget:(id)target action:(SEL)action
{
    [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
}

@end
