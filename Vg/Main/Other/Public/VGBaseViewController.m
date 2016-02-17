//
//  VGBaseViewController.m
//  Vg
//
//  Created by lwhua on 16/2/17.
//  Copyright © 2016年 lwhua. All rights reserved.
//

#import "VGBaseViewController.h"


@interface VGBaseViewController ()

@end

@implementation VGBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *mainView = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:mainView];
    NSLog(@"vc init");
    
}

- (void) viewDidAppear:(BOOL)animated{
    
    NSLog(@"进入页面->%@", [self class]);
    
}

- (void) dealloc {
    NSLog(@"销毁页面->%@", [self class]);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
