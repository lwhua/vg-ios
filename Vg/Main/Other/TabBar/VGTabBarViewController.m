//
//  VGTabBarViewController.m
//  Vg
//
//  Created by lwhua on 16/2/17.
//  Copyright © 2016年 lwhua. All rights reserved.
//

#import "VGTabBarViewController.h"
#import "BuyViewController.h"
#import "EatViewController.h"
#import "MeViewController.h"
#import "SeeViewController.h"


@interface VGTabBarViewController ()

@end

@implementation VGTabBarViewController

- (instancetype) init{
    if (self = [super init]) {
        NSArray *titleArray = @[ @"吃",@"买", @"看", @"我"];
        NSArray *imageArray = @[@"tab_eat",
                                @"tab_buy",
                                @"tab_see",
                                @"tab_me"];
        NSArray *selectedImageArray = @[@"tab_eat_press",
                                        @"tab_buy_press",
                                        @"tab_see_press",
                                        @"tab_me_press"];
        
        NSArray *controllerArray = @[
                         [[EatViewController alloc] init],
                         [[BuyViewController alloc] init],
                         [[SeeViewController alloc] init],
                         [[MeViewController alloc] init]
                         ];
        
        NSMutableArray *vcArray = [[NSMutableArray alloc] init];
        
        for (NSInteger i = 0; i < titleArray.count; i++) {
            UIViewController *controller = controllerArray[i];
            
            UITabBarItem *item = nil;
            item = [[UITabBarItem alloc] initWithTitle:titleArray[i]
                                                 image:[[UIImage imageNamed:imageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]
                                         selectedImage:[[UIImage imageNamed:selectedImageArray[i]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
            
            [item setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blueColor] } forState:UIControlStateSelected];
            controller.tabBarItem = item;
            
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:controller];
            
            [vcArray addObject:nav];
            nav = nil;
        }
        
        self.viewControllers = vcArray;
    }
    
    return  self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
