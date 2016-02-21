//
//  DatabaseWorker.h
//  KKBusiness
//
//  Created by lulucas on 9/19/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabase.h"


typedef void (^executeBlock)(FMDatabase *dbHelper);

@interface DatabaseWorker : NSObject

{
    NSDictionary *_result;
}

@property (nonatomic, copy) executeBlock execute;

// 启动
- (void)onStart:(FMDatabase *)dbHelper;
// 运行
- (void)onRun:(FMDatabase *)dbHelper;
// 结束
- (void)onFinished:(FMDatabase *)dbHelper;
// 失败
- (void)onFault:(FMDatabase *)dbHelper;
// 返回结果
- (NSDictionary *)onResult;

@end
