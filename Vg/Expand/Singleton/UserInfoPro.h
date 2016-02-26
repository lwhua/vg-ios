//
//  UserInfoPro.h
//  YSBPro
//
//  Created by lu lucas on 6/11/14.
//  Copyright (c) 2014 lu lucas. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface UserInfoPro : NSObject

+ (instancetype)shareInstance;


//下载队列
- (NSMutableArray *)downloadQueue;

//未完成的IAP的receipt
- (NSMutableArray *)unDoneIAPQueue;

- (NSMutableArray *)debugArray;

@end
