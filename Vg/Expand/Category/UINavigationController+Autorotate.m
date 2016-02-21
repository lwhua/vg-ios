//
//  UINavigationController+Autorotate.m
//  TestLandscape
//
//  Created by swhl on 13-4-16.
//  Copyright (c) 2013年 swhl. All rights reserved.
//

#import "UINavigationController+Autorotate.h"


@implementation UINavigationController (Autorotate)

- (BOOL)shouldAutorotate{
    return self.topViewController.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.topViewController.supportedInterfaceOrientations;
}


// 为了显示白色状态栏文字颜色 在view controller-based status bar style为yes在情况下
-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
