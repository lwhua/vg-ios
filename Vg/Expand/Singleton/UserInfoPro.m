//
//  UserInfoPro.m
//  YSBPro
//
//  Created by lu lucas on 6/11/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import "UserInfoPro.h"
#import "YSBProMacro.h"


@interface UserInfoPro ()
{
    NSMutableArray *_downloadQueue;
    NSMutableArray *_unDoneIAPQueue;
    
    NSMutableArray *_debugArray;
}

@end

@implementation UserInfoPro

+ (instancetype)shareInstance
{
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[[self class] alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    if (self = [super init]) {
        _downloadQueue = [NSMutableArray array];
        _unDoneIAPQueue = [NSMutableArray array];
        _debugArray = [NSMutableArray array];
//        self.paymentCore = [[PaymentCore alloc] init];
//        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_passRealName) name:NOTIFI_PASS_REALNAME object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(_userTokenOutTime:) name:NOTIFI_TOKEN_OUTTIME object:nil];
    }
    return self;
}




- (NSMutableArray *)downloadQueue
{
    return _downloadQueue;
}

- (NSMutableArray *)unDoneIAPQueue
{
    return _unDoneIAPQueue;
}

- (NSMutableArray *)debugArray
{
    return _debugArray;
}



@end
