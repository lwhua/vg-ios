//
//  DatabaseEngine.h
//  FMDB
//
//  Created by lulucas on 9/18/14.
//  Copyright (c) 2014 lulucas. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DatabaseWorker.h"


@interface DatabaseEngine : NSObject
/**
 *  初始化一个数据库
 *
 *  @param databaseDir  数据库目录/Library/Cache/databaseDir
 *  @param databaseName 数据库名字/Library/Cache/databaseDir/databaseName
 *
 *  @return 数据库引擎
 */
+ (id)shareInstanceWithDir:(NSString *)databaseDir name:(NSString *)databaseName;
/**
 *  添加数据库worker进行数据库操作
 *
 *  @param worker 一个描述某项数据库操作的worker
 *
 *  @return 数据库执行结果
 */
- (NSDictionary *)addDbWorker:(DatabaseWorker *)worker;

@end
