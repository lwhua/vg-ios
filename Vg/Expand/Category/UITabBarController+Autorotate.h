//
//  UITabBarController+Autorotate.h
//  YSBBusiness
//
//  Created by lu lucas on 20/11/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarController (Autorotate)

- (BOOL)shouldAutorotate;
- (UIInterfaceOrientationMask)supportedInterfaceOrientations;

@end
