//
//  UITabBarController+Autorotate.m
//  YSBBusiness
//
//  Created by lu lucas on 20/11/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import "UITabBarController+Autorotate.h"

@implementation UITabBarController (Autorotate)

- (BOOL)shouldAutorotate{
    return self.selectedViewController.shouldAutorotate;
}


- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return self.selectedViewController.supportedInterfaceOrientations;
}



@end
